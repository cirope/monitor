module Roles::Relations
  extend ActiveSupport::Concern

  included do
    has_many :users, dependent: :restrict_with_error
    has_many :permissions, dependent: :destroy

    accepts_nested_attributes_for :permissions, allow_destroy: true, reject_if: :all_blank
  end
end
