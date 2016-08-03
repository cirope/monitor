module Scripts::Parameters
  extend ActiveSupport::Concern

  included do
    has_many :parameters, dependent: :destroy

    accepts_nested_attributes_for :parameters, allow_destroy: true, reject_if: -> (attributes) {
      attributes['value'].blank?
    }
  end
end
