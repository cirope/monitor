class Tag < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Tags::Options
  include Tags::Scopes
  include Tags::Validation

  scope :ordered, -> { order name: :asc }

  strip_fields :name

  has_many :taggings, dependent: :destroy
  has_many :taggables, through: :taggings

  def to_s
    name
  end
end
