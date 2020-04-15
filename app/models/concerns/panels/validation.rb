# frozen_string_literal: true

module Panels::Validation
  extend ActiveSupport::Concern

  FUNCTIONS    = %w(count min max sum avg)
  OUTPUT_TYPES = %w(pie line)

  included do
    validates :title, :height, :width, :function, :output_type, presence: true
    validates :title,
      length:     { maximum: 255 },
      uniqueness: { case_sensitive: false, scope: :dashboard_id }
    validates :height, :width, numericality: {
      only_integer: true, greater_than: 0, less_than: 4
    }
    validates :function, inclusion: { in: Panel::FUNCTIONS }
    validates :output_type, inclusion: { in: Panel::OUTPUT_TYPES }
  end
end
