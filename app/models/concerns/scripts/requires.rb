# frozen_string_literal: true

module Scripts::Requires
  extend ActiveSupport::Concern

  included do
    has_many :requires, dependent: :destroy, foreign_key: :caller_id
    has_many :dependants, dependent: :destroy, class_name: 'Require'
    has_many :includes, through: :requires, source: :script

    accepts_nested_attributes_for :requires, allow_destroy: true, reject_if: :all_blank
  end
end
