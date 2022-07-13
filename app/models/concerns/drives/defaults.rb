module Drives::Defaults
  extend ActiveSupport::Concern

  included do
    before_validation :set_identifer
  end

  private

    def set_identifer
      self.identifier ||= SecureRandom.hex
    end
end
