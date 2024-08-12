# frozen_string_literal: true

module Users::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, :lastname, presence: true
    validates :name, :lastname, :email, :username, length: { maximum: 255 }
    validates :username, uniqueness: { case_sensitive: false }
    validates :email,
      uniqueness: { case_sensitive: false },
      presence: true,
      format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

    validate :email_is_not_globally_taken,
             :username_is_not_globally_taken
    validate :user_recovery, if: :validate_recovery?
  end

  private

    def email_is_not_globally_taken
      if persisted? && email_changed? && Membership.where(email: email).exists?
        errors.add :email, :globally_taken
      end
    end

    def username_is_not_globally_taken
      others = Membership.where(username: username).where.not email: email
      taken  = persisted?            &&
               username_changed?     &&
               username.present?     &&
               username_was.present? &&
               others.exists?

      errors.add :username, :globally_taken if taken
    end

    def user_recovery
      user_recovery = taggings.reject(&:marked_for_destruction?).map(&:tag).any? &:recovery?

      errors.add :tags, :user_recovery_tag_empty unless user_recovery
    end

    def validate_recovery?
      (Ldap.default || Saml.default) && manual?
    end
end
