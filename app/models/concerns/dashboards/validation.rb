# frozen_string_literal: true

module Dashboards::Validation
  extend ActiveSupport::Concern

  included do
    validates :name,
      presence:   true,
      length:     { maximum: 255 },
      uniqueness: { case_sensitive: false, scope: :user_id }
  end
end
