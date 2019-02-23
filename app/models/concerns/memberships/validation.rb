module Memberships::Validation
  extend ActiveSupport::Concern

  included do
    validates :email, :account, presence: true
    validates :email, uniqueness: { case_sensitive: false, scope: :account }
    validate :username_with_unique_email
  end

  private

    def username_with_unique_email
      membership_with_different_email = Membership.
        where(username: username).
        where.not(email: email_was || email)

      errors.add :username, :taken if membership_with_different_email.exists?
    end
end
