# frozen_string_literal: true

module Servers::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :hostname, presence: true
    validates :name, :hostname, :user, :password, length: { maximum: 255 }
    validate :user_or_credential?
  end

  private

    def user_or_credential?
      errors.add :user, :blank if user.blank? && credential.blank?
    end
end
