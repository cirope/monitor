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

      limit ? result.limit(limit) : result
    end
  end
end
