# frozen_string_literal: true

module Databases::Properties
  extend ActiveSupport::Concern

  included do
    has_many :properties, dependent: :destroy
    accepts_nested_attributes_for :properties, allow_destroy: true, reject_if: :all_blank
  end

  def property key
    properties.detect { |property| property.key == key }&.value
  end
end
