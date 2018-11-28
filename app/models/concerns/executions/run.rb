module Executions::Run
  extend ActiveSupport::Concern

  def run
    self.update(
      started_at: Time.zone.now,
      status: :running
    )

    server.run_execution self

    self.ended_at = Time.zone.now

    # Fake PaperTrail change output
    updated_output = self.output
    self.output = ''
    self.clear_attribute_changes([:output])
    self.output = updated_output

    ExecutionChannel.send_line id, '', status: status

    self.save!
  end

  def update_output line
    PaperTrail.request(enabled: false) do
      update(
        output: [output, line].compact.join("\n")
      )

      ExecutionChannel.send_line id, line, status: status
    end
  end
end
