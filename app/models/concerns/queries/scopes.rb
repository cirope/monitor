# frozen_string_literal: true

module Queries::Scopes
  extend ActiveSupport::Concern

  module ClassMethods
    def filters
      Serie.distinct.pluck :name
    end
  end
end
