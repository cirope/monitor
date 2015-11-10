module Issues::Subscriptions
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, dependent: :destroy
    accepts_nested_attributes_for :subscriptions, allow_destroy: true, reject_if: :all_blank
  end
end
