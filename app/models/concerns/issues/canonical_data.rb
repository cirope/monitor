# frozen_string_literal: true

module Issues::CanonicalData
  extend ActiveSupport::Concern

  included do
    before_save :set_canonical_data, if: :update_canonical_data?
  end

  private

    def update_canonical_data?
      data_changed? && data_type == 'single_row'
    end

    def set_canonical_data
      self.canonical_data = converted_data.first
    end
end
