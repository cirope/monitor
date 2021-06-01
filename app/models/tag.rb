# frozen_string_literal: true

class Tag < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Tags::Destroy
  include Tags::Effects
  include Tags::Options
  include Tags::Parent
  include Tags::Scopes
  include Tags::Validation

  scope :ordered, -> { order name: :asc }

  strip_fields :name

  has_many :taggings, dependent: :destroy

  has_many :users,   through: :taggings, source: :taggable, source_type: 'User'
  has_many :issues,  through: :taggings, source: :taggable, source_type: 'Issue'
  has_many :scripts, through: :taggings, source: :taggable, source_type: 'Script'

  def to_s
    name
  end
end
