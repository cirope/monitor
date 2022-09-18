module Scripts::Libraries
  extend ActiveSupport::Concern

  included do
    has_many :libraries, dependent: :destroy, inverse_of: :script

    accepts_nested_attributes_for :libraries, allow_destroy: true, reject_if: -> (attributes) {
      attributes['name'].blank?
    }
  end
end
