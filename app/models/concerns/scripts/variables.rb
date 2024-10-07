# frozen_string_literal: true

module Scripts::Variables
  extend ActiveSupport::Concern

  included do
    has_many :variables, dependent: :destroy, inverse_of: :script

    accepts_nested_attributes_for :variables, allow_destroy: true, reject_if: -> (attributes) {
      attributes['value'].blank?
    }
  end
end
