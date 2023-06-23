# frozen_string_literal: true

module Schedules::Jobs
  extend ActiveSupport::Concern

  included do
    has_many :jobs, -> { where hidden: false }, dependent: :destroy, autosave: true
    has_many :scripts, through: :jobs
    accepts_nested_attributes_for :jobs, allow_destroy: true, reject_if: :all_blank
  end
end
