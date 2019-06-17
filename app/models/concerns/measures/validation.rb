# frozen_string_literal: true

module Measures::Validation
  extend ActiveSupport::Concern

  included do
    validates :cpu, :memory_in_bytes, presence: true
    validates :cpu, numericality: {
      less_than_or_equal_to: 9999.9, greater_than_or_equal_to: 0
    }, allow_blank: true
    validates :memory_in_bytes, numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 9_223_372_036_854_775_807
    }, allow_blank: true
  end
end
