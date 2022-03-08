# frozen_string_literal: true

module Fails::Scopes
  extend ActiveSupport::Concern

  module ClassMethods
    def by_date range_as_string
      dates = range_as_string.split(/\s*-\s*/).map do |d|
        Timeliness.parse d rescue nil
      end
      start  = dates.first
      finish = dates.last

      start && finish ? where(created_at: start..finish) : all
    end

    def by_user username
      left_joins(:user)
        .where("#{User.table_name}.username ILIKE ?", "%#{username}%")
    end
  end
end
