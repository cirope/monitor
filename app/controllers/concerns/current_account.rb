# frozen_string_literal: true

module CurrentAccount
  extend ActiveSupport::Concern

  included do
    helper_method :current_account if respond_to? :helper_method
  end

  def current_account
    @current_account ||= get_current_account
  end

  private

    def get_current_account
      Current.account = Account.find_by tenant_name: Apartment::Tenant.current
    end
end
