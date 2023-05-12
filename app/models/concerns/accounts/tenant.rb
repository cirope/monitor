# frozen_string_literal: true

module Accounts::Tenant
  extend ActiveSupport::Concern

  included do
    after_create  :create_tenant, :create_roles
    after_destroy :destroy_tenant
  end

  def switch
    current = Current.account
    account = self

    Apartment::Tenant.switch tenant_name do
      Current.account = account

      yield
    end
  ensure
    Current.account = current
  end

  def switch!
    Apartment::Tenant.switch! tenant_name
  end

  module ClassMethods
    def current
      where tenant_name: Apartment::Tenant.current
    end
  end

  private

    def create_tenant
      Apartment::Tenant.create tenant_name
    end

    def create_roles
      switch do
        ROLES.each { |type, params| Role.create! params.merge(type: type) }
      end
    end

    def destroy_tenant
      if Apartment.connection.schema_exists? tenant_name
        Apartment::Tenant.drop tenant_name
      end
    end
end
