# frozen_string_literal: true

module Users::Licenses
  extend ActiveSupport::Concern

  included do
    LICENSED_USERS = ['manager', 'author', 'supervisor']

    before_save :check_licensed_user_limit, if: :should_check_licensed_user?

    scope :licensed_user, -> { visible.joins(:role).where(roles: { type: LICENSED_USERS }) }
  end

  private

    def check_licensed_user_limit
      if self.class.licensed_user.count >= licensed_user_limit
        Rails.logger.info "Licensed user limit reached (#{licensed_user_limit})"
        errors.add :base, :licensed_user_limit

        throw :abort
      end
    end

    def licensed_user_limit
      Rails.application.credentials.max_licensed_users_count[Apartment::Tenant.current.to_sym] ||
        Rails.application.credentials.max_licensed_users_count[:global]
    end

    def should_check_licensed_user?
      LICENSED_USERS.include? role.type
    end
end
