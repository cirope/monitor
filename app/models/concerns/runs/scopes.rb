# frozen_string_literal: true

module Runs::Scopes
  extend ActiveSupport::Concern

  included do
    scope :overdue,          -> { overdue_by 1, 'days' }
    scope :ordered,          -> { order scheduled_at: :desc }
    scope :next_to_schedule, -> {
      pending.where "#{table_name}.scheduled_at <= ?", 10.minutes.from_now
    }
  end

  module ClassMethods
    def by_scheduled_at range_as_string
      dates = range_as_string.split(/\s*-\s*/).map do |d|
        Timeliness.parse d rescue nil
      end
      start  = dates.first
      finish = dates.last

      start && finish ? where(scheduled_at: start..finish) : all
    end

    def by_script_name name
      joins(:script).where "#{Script.table_name}.name ILIKE ?", "%#{name}%"
    end

    def overdue_by interval, frequency
      scheduled_at = Time.zone.now.advance frequency.to_sym => -(interval || 1)

      scheduled.where "#{table_name}.scheduled_at <= ?", scheduled_at
    end
  end
end
