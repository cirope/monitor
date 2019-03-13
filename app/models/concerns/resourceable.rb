module Resourceable
  extend ActiveSupport::Concern

  INTERVAL_BETWEEN_READS = 2.seconds
  TOP_COMMAND = "HOME=#{::Rails.root.join('lib', 'top')} top"

  included do
    has_many :resource_stats, as: :resourceable
  end

  def start_profiler
    # [PID USER RES %CPU %MEM TIME+ COMMAND]
    command = "#{TOP_COMMAND} -p #{Process.pid} -n 1 -b| tail -n 1".freeze

    @_profiler = Thread.new {
      loop do
        pid, memory, cpu, memory_p = *IO.popen(command).read.split(' ')

        if pid.to_i > 0
          puts memory_p.to_f
          resource_stats.create(
            cpu:               cpu.to_f.round(1),
            memory_percentage: memory_p.to_f.round(1),
            memory:            memory # ver que hacemos con esta
          )
        end

        sleep INTERVAL_BETWEEN_READS
      end
    }
  end

  def stop_profiler
    @_profiler.try(:kill)
  end
end
