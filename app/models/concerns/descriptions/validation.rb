# frozen_string_literal: true

module Descriptions::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, :value, presence: true, format: { without: /[{}]/ }
    validates :name, length: { maximum: 255 }
  end
end
