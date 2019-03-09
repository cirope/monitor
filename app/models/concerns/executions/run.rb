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
    output.tap do |current_output|
      self.output = ''

      clear_attribute_changes [:output]

      self.output = current_output
    end

    ExecutionChannel.send_line id, line:   nil,
                                   order:  lines_count.next,
                                   status: status

    save!
  end

  def new_line line
    PaperTrail.request enabled: false do
      update! output: [output, line].compact.join

      ExecutionChannel.send_line id, line:   line,
                                     order:  lines_count,
                                     status: status
    end
  end

  private

    def lines_count
      output.lines.size
    end
end
