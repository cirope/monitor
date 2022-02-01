# frozen_string_literal: true

module Issues::CanonicalData
  extend ActiveSupport::Concern

  included do
    before_save :set_canonical_data, if: :update_canonical_data?
  end

  private

    def update_canonical_data?
      (data_type == 'single_row' || data_type == 'empty') && data_changed?
    end

    def set_canonical_data
      self.canonical_data = case data_type
                                 when 'single_row'
                                   converted_data.first
                                 when 'empty'
                                   {}
                                 end
    end
end
