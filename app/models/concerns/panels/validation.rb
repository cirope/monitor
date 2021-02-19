# frozen_string_literal: true

module Panels::Validation
  extend ActiveSupport::Concern

  included do
    validates :title, :height, :width, presence: true
    validates :title,
      length:     { maximum: 255 },
      uniqueness: { case_sensitive: false, scope: :dashboard_id }
    validates :width, :height, numericality: {
      only_integer: true, greater_than: 0, less_than: 4
    }
  end
end
