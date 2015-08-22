class Tag < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Tags::Validation

  scope :ordered, -> { order name: :asc }

  strip_fields :name

  def to_s
    name
  end
end
