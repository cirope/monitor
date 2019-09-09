# frozen_string_literal: true

module Schedules::Dispatchers
  extend ActiveSupport::Concern

  included do
    has_many :dispatchers, dependent: :destroy, autosave: true
    accepts_nested_attributes_for :dispatchers, allow_destroy: true, reject_if: :all_blank
  end
end
