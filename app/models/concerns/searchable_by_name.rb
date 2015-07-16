module SearchableByName
  extend ActiveSupport::Concern

  module ClassMethods
    def search query: nil, limit: false
      result = ordered

      if query.present?
        result = result.where "#{table_name}.name ILIKE ?", "%#{query.strip}%"
      end

      limit ? result.limit(limit) : result
    end
  end
end
