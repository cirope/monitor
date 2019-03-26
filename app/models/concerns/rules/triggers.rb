# frozen_string_literal: true

module Rules::Triggers
  extend ActiveSupport::Concern

  included do
    has_many :triggers, dependent: :destroy

    accepts_nested_attributes_for :triggers, allow_destroy: true, reject_if: :all_blank
  end
end
