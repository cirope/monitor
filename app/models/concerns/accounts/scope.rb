module Accounts::Scope
  extend ActiveSupport::Concern

  module ClassMethods
    def by_name name
      where "#{table_name}.name ILIKE ?", "%#{name}%"
    end

    def by_tenant_name tenant_name
      where "#{table_name}.tenant_name ILIKE ?", "%#{tenant_name}%"
    end
  end
end
