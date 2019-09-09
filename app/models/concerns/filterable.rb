# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by params
      results = all

      params.each do |param, value|
        results = results.public_send("by_#{param}", value) if value.present?
      end

      results
    end
  end
end
