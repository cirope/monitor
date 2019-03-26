# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings

    accepts_nested_attributes_for :taggings, allow_destroy: true, reject_if: :all_blank
  end

  module ClassMethods
    def tagged_with *tags
      joins(:tags).where(tags: { name: tags }).distinct
    end

    def by_tags tags
      tagged_with *tags.split(/\s*,\s*/)
    end

    def not_tagged
      left_joins(:taggings).where(taggings: { id: nil }).references :taggings
    end
  end
end
