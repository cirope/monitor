# frozen_string_literal: true
class SystemProcess
  attr_accessor :pid

  def initialize pid
    @pid = pid
  end

  def cpu_percent interval: 1.0
    return 0.0 unless still_running?

    before_cpu_cycles, before_process_cycles = *cpu_and_proc_cycles

    sleep interval

    after_cpu_cycles, after_process_cycles = *cpu_and_proc_cycles

    net_process_cycles = after_process_cycles - before_process_cycles
    net_cpu_cycles     = after_cpu_cycles     - before_cpu_cycles

    if net_process_cycles.positive? && net_cpu_cycles.positive?
      ((net_process_cycles / net_cpu_cycles.to_f) * 100.0).round 1
    else
      0.0
    end
  end

  def cpu_and_proc_cycles
    [self.class.current_cpu_cycles, current_process_cycles]
  end

  def proc_stat
    # some processes put names like (Web Content) instead of (Web_Content)
    File.read("/proc/#{pid}/stat").sub(/\(.*\)/, '_').split if still_running?
  end

  def still_running?
    File.exist? "/proc/#{pid}/stat"
  end

  def current_process_cycles
    # 13 = utime / 14 = stime
    data = proc_stat.values_at(13, 14).compact if still_running?

    data.map(&:to_i).sum if data.present?
  end

  def virtual_memory
    proc_stat[22].to_i if still_running?
  end

  def memory
    proc_stat[23].to_i * self.class.vm_page_size if still_running?
  end

  def memory_percent
    (memory.to_f / self.class.memory_info[:total] * 100.0).round 1 if still_running?
  end

  def command
    @command ||= File.read "/proc/#{pid}/cmdline" if still_running?
  end

  def created_at
    # 21 start_time after system boot
    self.class.boot_time + (proc_stat[21].to_f / self.class.clock_ticks) if still_running?
  end

  def time_running
    Time.now.to_i - created_at if still_running?
  end

  def kill
    ::Process.kill 'SIGKILL', pid.to_i
  end

  # System information
  def self.boot_time
    @@_boot_time ||= File.readlines('/proc/stat').grep(/\Abtime/).first.split.last.to_i
  end

  def self.processors
    @@_processors ||= File.readlines('/proc/cpuinfo').grep(/\Aprocessor/).size
  end

  def self.vm_page_size
    @@_vm_page_size ||= %x{getconf PAGE_SIZE}.to_i
  end

  def self.clock_ticks
    @@_clock_ticks ||= %x{getconf CLK_TCK}.to_i
  end

  # System Utils
  def self.current_cpu_cycles
    data   = File.readlines('/proc/stat').first.sub(/\Acpu\s+/, '').split
    cycles = data.map(&:to_i).sum if data.present?

    cycles && (cycles / processors.to_f)
  end

  def self.memory_info
    memory = {}

    File.readlines('/proc/meminfo').each do |line|
      key, size = line.split ':'

      case key
      when 'MemTotal' then memory[:total] = size.to_i * 1024
      end
    end

    memory
  end

  def self.user_top order_by: :vmemory
    user_option = RUBY_PLATFORM.include?('darwin') ? '-U' : '--user'
    field       = case order_by
                  when :vmemory then '$5'
                  when :memory  then '$4'
                  when :cpu     then '$3'
                  end

    # $2 => PID  $3 => %CPU  $4 => %MEM  $5 => VSZ
    top_pids = %x{
      ps aux #{user_option} $USER |
      awk '{ print $2, #{field}}' |
      sort -k2nr |
      head -n 10 |
      awk '{ print $1 }'
    }.split "\n"

    ruby_pids  = %x{pgrep ruby}.split "\n"
    ruby_pids += %x{pgrep sidekiq}.split "\n"
    ruby_pids += %x{pgrep rails}.split "\n"

    threads = (ruby_pids + top_pids).uniq.map do |pid|
      Thread.new do
        p = new pid

        OpenStruct.new(
          command:        p.command,
          memory:         p.memory,
          memory_percent: p.memory_percent,
          cpu:            p.cpu_percent,
          pid:            p.pid,
          time:           p.time_running
        )
      end
    end

    threads.each &:join

    threads.map(&:value).reject { |p| p.memory.blank? && p.cpu.zero? }
  end
end
