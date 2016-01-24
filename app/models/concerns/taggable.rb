module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings

    accepts_nested_attributes_for :taggings, allow_destroy: true, reject_if: :all_blank
  end

  module ClassMethods
    def tagged_with *tags
      joins(:tags).where(tags: { name: tags }).uniq
    end
  end
end
