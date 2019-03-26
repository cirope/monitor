# frozen_string_literal: true

module Schedules::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order end: :desc, start: :asc, id: :asc }
    scope :visible, -> { where hidden: false }
  end

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
