# frozen_string_literal: true

module Issues::CanonicalData
  extend ActiveSupport::Concern

  included do
    serialize :canonical_data, JSON

    before_save :set_canonical_data, if: :should_set_canonical_data?
  end

  private

    def should_set_canonical_data?
      data_changed? || options_changed?
    end

    def set_canonical_data
      self.canonical_data = case data_type
                            when 'single_row'
                              converted_data.first
                            when 'custom_row'
                              converted_data.dig options.dig('custom_row', 'key')
                            else
                              nil
                            end
    end
end
