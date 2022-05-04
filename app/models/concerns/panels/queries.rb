module Panels::Queries
  extend ActiveSupport::Concern

  included do
    belongs_to :dashboard
    has_many :queries, dependent: :destroy
    accepts_nested_attributes_for :queries, allow_destroy: true, reject_if: :all_blank
  end
end
