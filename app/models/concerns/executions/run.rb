module Executions::Run
  extend ActiveSupport::Concern

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

  def run_with_profiler
    start_profiler

    run

    stop_profiler
  rescue => e
    stop_profiler
    raise e
  end
end
