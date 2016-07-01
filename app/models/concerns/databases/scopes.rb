module Databases::Scopes
  extend ActiveSupport::Concern

  module ClassMethods
    def by_name name
      where "#{table_name}.name ILIKE ?", "%#{name}%"
    end

    def by_driver driver
      where "#{table_name}.driver ILIKE ?", "%#{driver}%"
    end
  end
end
