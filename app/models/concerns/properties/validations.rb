# frozen_string_literal: true

module Properties::Validations
  extend ActiveSupport::Concern

  included do
    validates :key, :value, presence: true, length: { maximum: 255 }
  end
end
