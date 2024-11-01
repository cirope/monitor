# frozen_string_literal: true

module Issues::CanonicalData
  extend ActiveSupport::Concern

  included do
    before_save :set_canonical_data, if: :should_set_canonical_data?
  end

  private

    def should_set_canonical_data?
      data_changed? || options_changed?
    end

    def set_canonical_data
      self.canonical_data = case data_type
                            when 'single_row' then converted_data.first
                            when 'custom_row' then converted_data
                            else
                              nil
                            end
    end
end
