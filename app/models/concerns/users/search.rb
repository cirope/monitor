# frozen_string_literal: true

module Users::Search
  extend ActiveSupport::Concern

  module ClassMethods
    def search query: nil, limit: false
      result = ordered

      if query.present?
        result = result.where("#{table_name}.name ILIKE ?", "%#{query.strip}%").
          or result.where("#{table_name}.lastname ILIKE ?", "%#{query.strip}%")
      end

      result
    end

    def by_username_or_email username
      where(username: username.to_s.strip.downcase).
        or(where(email: username.to_s.strip.downcase)).take
    end
  end
end
