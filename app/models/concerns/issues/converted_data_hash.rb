# frozen_string_literal: true

module Issues::ConvertedDataHash
  extend ActiveSupport::Concern

  included do
    before_save :set_converted_data_hash, if: :update_converted_data_hash?
  end

  private

    def update_converted_data_hash?
      (data_type == 'single_row' || data_type == 'empty') && data_changed?
    end

    def set_converted_data_hash
      self.converted_data_hash = case data_type
                                 when 'single_row'
                                   converted_data.first
                                 when 'empty'
                                   {}
                                 end
    end
end
