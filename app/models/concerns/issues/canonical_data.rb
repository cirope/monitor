# frozen_string_literal: true

module Issues::CanonicalData
  extend ActiveSupport::Concern

  included do
    serialize :canonical_data, JSON

    before_save :set_canonical_data, if: :data_changed?
  end

  private

    def set_canonical_data
      self.canonical_data = (data_type == 'single_row' ? converted_data.first : nil)
    end
end
