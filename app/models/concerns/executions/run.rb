module Executions::Run
  extend ActiveSupport::Concern
  TOPRC_HOME ||= ::Rails.root.join('lib', 'top')

  def run
    update(
      status:     :running,
      started_at: Time.zone.now
    )

    self.status   = server.execution self
    self.ended_at = Time.zone.now

    # Fake PaperTrail change output
    self.output.tap do |current_output|
      self.output = ''

      clear_attribute_changes [:output]

      self.output = current_output
    end

    ExecutionChannel.send_line id, '', status: status

    save!
  end

  def new_line line
    PaperTrail.request enabled: false do
      update! output: [output, line].compact.join("\n")

      ExecutionChannel.send_line id, line, status: status
    end
  end

  def check_process
    command = "HOME=#{TOPRC_HOME} top -p #{Process.pid} -n 1 -b| tail -n 1"
    # [PID USER RES %CPU %MEM TIME+ COMMAND]
    Thread.new {
      loop do
        pid, memory, cpu, memory_p = *IO.popen(command).read.split(' ')

        if pid.to_i > 0
          register_resources(
            cpu:               cpu,
            memory_percentage: memory_p,
            memory:            memory
          )
        end
        # break unless self.running?
        sleep 2 # o lo que sea
      end
    }
  end

  def register_resources(keys)
    puts keys
  end

  def manso
    self.status = :pending
    tanga = Thread.new {

      @a = []
      begin
        Timeout.timeout(10) do
          @a = []
          loop { @a << 3*3*3*3*3*3*3*3*3*rand*rand*rand }
        end
      rescue Timeout::Error => e
      end
    }
    self.check_process
    tanga.join
  end
end
