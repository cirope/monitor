module Scripts::Descriptions
  extend ActiveSupport::Concern

  included do
    has_many :descriptions, dependent: :destroy

    accepts_nested_attributes_for :descriptions, allow_destroy: true, reject_if: -> (attributes) {
      attributes['value'].blank?
    }
  end
end
