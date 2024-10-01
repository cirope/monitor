# frozen_string_literal: true

module SearchableByName
  extend ActiveSupport::Concern

  module ClassMethods
    def search query: nil, lang: nil
      result = ordered

      if query.present?
        result = result.where "#{table_name}.name ILIKE ?", "%#{query.strip}%"
      end

      if lang.present?
        result = result.where "#{table_name}.language ILIKE ?", "%#{lang.strip}%"
      end

      result
    end
  end
end
