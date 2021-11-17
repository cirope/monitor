# frozen_string_literal: true

module Users::Licenses
  extend ActiveSupport::Concern

  included do
    before_save :check_licensed_user_limit, if: :should_check_licensed_user?

    scope :licensed_user, -> { where(role: ['manager', 'author', 'supervisor']) }
  end

  private

    def check_licensed_user_limit
      if licensed_user.count >= licensed_user_limit
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

    def should_check_licensed_user?
      new_record? || change_to_licensed_user?
    end

    def change_to_licensed_user?
      was_not_licensed_user? && going_to_be_a_licensed_user?
    end

    def was_not_licensed_user?
      ['manager', 'author', 'supervisor'].exclude? role_was
    end

    def going_to_be_a_licensed_user?
      manager? || author? || supervisor?
    end
end
