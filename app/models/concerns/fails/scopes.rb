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

    def by_user user_name
      left_outer_joins(:user)
        .where('(user_id is not null and lower(users.name) like :user_name)'\
               "or (lower(data ->> 'user_name') like :user_name)", user_name: "%#{user_name.downcase}%")
    end
  end
end
