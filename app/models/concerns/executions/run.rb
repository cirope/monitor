# frozen_string_literal: true

module Executions::Run
  extend ActiveSupport::Concern

  def run
    update(
      status:     'running',
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

    save!
  end

  def new_line line
    PaperTrail.request enabled: false do
      update! output: [output, line].compact.join

      ExecutionChannel.send_line id, line:     line,
                                     order:    lines_count,
                                     status:   status,
                                     pid:      pid,
                                     finished: finished?
    end
  end

  private

    def lines_count
      output.to_s.lines.size
    end
end
