# frozen_string_literal: true

module Issues::Subscriptions
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, dependent: :destroy
    accepts_nested_attributes_for :subscriptions, allow_destroy: true, reject_if: :reject_subscription?
  end

  private

    def reject_subscription? attributes
      all_blank = attributes.values.all? &:blank?

      all_blank || subscriptions.detect do |subscription|
        subscription.user_id == attributes['user_id'].to_i
      end
    end
end
