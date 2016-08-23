module Databases::Properties
  extend ActiveSupport::Concern

  included do
    has_many :properties, dependent: :destroy
    accepts_nested_attributes_for :properties, allow_destroy: true, reject_if: :all_blank
  end

  def property key
    properties.detect { |property| property.key == key }&.value
  end

  module ClassMethods
    def property_of name, key
      find_by(name: name)&.property key
    end
  end
end
