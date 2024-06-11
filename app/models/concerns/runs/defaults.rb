module Runs::Defaults
  extend ActiveSupport::Concern

  included do
    before_validation :set_default_script, :set_default_server
  end

  private

    def set_default_script
      self.script ||= job&.script
    end

    def set_default_server
      self.server ||= job&.server
    end
end
