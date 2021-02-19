# frozen_string_literal: true

module Queries::Defaults
  extend ActiveSupport::Concern

  included do
    before_validation :set_defaults, :set_from_to_at
  end

  private

    def set_defaults
      self.filters = filters.delete_if(&:blank?) if filters
    end

    def set_from_to_at
      fromto = range ? get_range : get_period

      if fromto
        self.from_at = fromto.first
        self.to_at   = fromto.last
      end
    end
end
