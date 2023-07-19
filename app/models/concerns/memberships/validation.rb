# frozen_string_literal: true

module Memberships::Validation
  extend ActiveSupport::Concern

  included do
    validates :email, :account, presence: true
    validates :email, :username, uniqueness: {
      case_sensitive: false, scope: :account
    }
    validate :username_with_unique_email, if: :should_validate_username_with_unique_email
  end

  private

    def should_validate_username_with_unique_email
      new_record? && !restore
    end

    def username_with_unique_email
      membership_with_different_email = Membership.
        where(username: username).
        where.not email: email

      if username.present? && membership_with_different_email.exists?
        errors.add :username, :taken
        user&.errors&.add :username, :globally_taken
      end
    end
end
