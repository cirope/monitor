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
      # TODO: change to key.blank? on Rails 6 (on 5.2 it does not work)
      errors.add :user, :blank if user.blank? && !key.attached?
    end
end
