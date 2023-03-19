module Roles::Identifer
  extend ActiveSupport::Concern

  included do
    before_validation :set_identifier
  end

  private

    def set_identifier
      self.identifier = nil if identifier.blank?
    end
end
