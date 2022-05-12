# frozen_string_literal: true

module Databases::Search
  extend ActiveSupport::Concern

  module ClassMethods
    def search query: nil, limit: false
      result = ordered

      if query.present?
        result = result.where "#{table_name}.name ILIKE ?", "%#{query.strip}%"
      end

      result
    end
  end
end
