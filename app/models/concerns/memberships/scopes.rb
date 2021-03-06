# frozen_string_literal: true

module Memberships::Scopes
  extend ActiveSupport::Concern

  included do
    scope :default, -> { where default: true }
    scope :current, -> { where account_id: Current.account&.id }
  end

  module ClassMethods
    def all_by_username_or_email username
      where(email: username.to_s.strip.downcase).
        or where(username: username.to_s.strip.downcase)
    end

    def by_name name
      joins(:account).references(:accounts).merge Account.by_name(name)
    end

    def by_tenant_name tenant_name
      joins(:account).
        references(:accounts).
        merge Account.by_tenant_name(tenant_name)
    end
  end
end
