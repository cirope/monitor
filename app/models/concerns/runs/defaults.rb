module Runs::Defaults
  extend ActiveSupport::Concern

  included do
    before_create :set_defaults
  end

  private

    def set_defaults
      self.script ||= job.script
      self.server ||= job.server
    end
end
