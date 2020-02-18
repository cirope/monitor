# frozen_string_literal: true

module Subscriptions::Validation
  extend ActiveSupport::Concern

  included do
    validates :user, presence: true
    validates :user_id, uniqueness: { scope: :issue_id }
  end
end
