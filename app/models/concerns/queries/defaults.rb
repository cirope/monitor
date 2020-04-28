# frozen_string_literal: true

module Queries::Defaults
  extend ActiveSupport::Concern

  included do
    before_validation :set_defaults
  end

  private

    def set_defaults
      self.filters = filters.delete_if(&:blank?) if filters
    end
end
