# frozen_string_literal: true

module Executions::Run
  extend ActiveSupport::Concern

  def run
    update(
      status:     'running',
      started_at: Time.zone.now
    )

    self.status, self.stderr = server.execution self
    self.ended_at = Time.zone.now

    # Fake PaperTrail change stdout
    stdout.tap do |current_stdout|
      self.stdout = ''

      clear_attribute_changes [:stdout]

      self.stdout = current_stdout
    end

    save!
  end

  def new_line line
    PaperTrail.request enabled: false do
      update! stdout: [stdout, line].compact.join

      ExecutionChannel.send_line id, line:     line,
                                     order:    lines_count,
                                     status:   status,
                                     pid:      pid,
                                     finished: finished?
    end
  end

  private

    def lines_count
      stdout.to_s.lines.size
    end
end
