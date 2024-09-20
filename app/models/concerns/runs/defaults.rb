module Runs::Defaults
  extend ActiveSupport::Concern

  included do
    # Some flows trigger the validation callback and others the create callback
    before_validation :set_defaults
    before_create :set_defaults
  end

  private

    def set_defaults
      self.script ||= job.script
      self.server ||= job.server
    end
end
