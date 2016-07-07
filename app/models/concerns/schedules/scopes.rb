module Schedules::Scopes
  extend ActiveSupport::Concern

  module ClassMethods
    def by_name name
      where "#{table_name}.name ILIKE ?", "%#{name}%"
    end

    def by_interval interval
      where interval: interval
    end

    def by_frequency frequency
      where frequency: frequency
    end
  end
end
