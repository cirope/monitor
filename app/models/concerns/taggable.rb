# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern

  included do
    before_validation :add_implied_tags

    has_many :taggings, as:         :taggable,
                        dependent:  :destroy,
                        inverse_of: :taggable,
                        after_add:  :add_implied

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

    def not_hidden
      left_joins(:tags).where(
        "(options->'hide') IS NULL"
      ).or(
        where.not('options @> ?', { hide: true }.to_json)
      )
    end
  end

  private

    def add_implied tagging
      if tagging.tag&.effects.present?
        tagging.tag.effects.each do |effect|
          unless taggings.any? { |t| t.tag == effect.implied }
            taggings << Tagging.new(tag: effect.implied)
          end
        end
      end
    end

    def add_implied_tags
      taggings.select(&:new_record?).each do |tagging|
        add_implied tagging
      end
    end
end
