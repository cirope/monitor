# frozen_string_literal: true

module Scripts::Maintainers
  extend ActiveSupport::Concern

  included do
    has_many :maintainers, dependent: :destroy
    has_many :users, through: :maintainers

    accepts_nested_attributes_for :maintainers, allow_destroy: true, reject_if: :all_blank
  end
end
