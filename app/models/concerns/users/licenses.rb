# frozen_string_literal: true

module Users::Licenses
  extend ActiveSupport::Concern

  included do
    before_save :check_licensed_user_limit, if: :licensed_user?

    scope :licensed_user, -> { where(role: ['manager', 'author', 'supervisor']).count }
  end

  private

    def check_licensed_user_limit
      if licensed_user >= licensed_user_limit
        Rails.logger.info I18n.t('errors.messages.logger_licensed_user_limit'),
                          limit: licensed_user_limit
        errors.add :base, :licensed_user_limit

        throw :abort
      end
    end

    def licensed_user_limit
      Rails.application.credentials.max_licensed_users_count[Apartment::Tenant.current.to_sym] ||
        Rails.application.credentials.max_licensed_users_count[:global]
    end

    def licensed_user?
      manager? || author? || supervisor?
    end
end
