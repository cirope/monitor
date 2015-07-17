module Schedules::Dependencies
  extend ActiveSupport::Concern

  included do
    has_many :dependencies, dependent: :destroy, foreign_key: :dependent_id
    has_many :dependants, dependent: :destroy, class_name: 'Dependency'
    has_many :required, through: :dependencies, source: :schedule

    accepts_nested_attributes_for :dependencies, allow_destroy: true, reject_if: :all_blank
  end
end
