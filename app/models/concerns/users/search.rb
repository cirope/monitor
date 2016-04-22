module Users::Search
  extend ActiveSupport::Concern

  module ClassMethods
    def search query: nil, limit: false
      result = ordered

      if query.present?
        condition = [
          "#{table_name}.name ILIKE :q",
          "#{table_name}.lastname ILIKE :q"
        ].join(' OR ')

        result = result.where condition, q: "%#{query.strip}%"
      end

      result
    end

    def by_username_or_email username
      condition = [
        "#{table_name}.username = :username",
        "#{table_name}.email = :username"
      ].join(' OR ')

      where(condition, username: username.to_s.strip.downcase).take
    end
  end
end
