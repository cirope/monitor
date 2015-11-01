class Rule < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Rules::Triggers

  validates :name, presence: true

  scope :ordered, -> { order :name }

  strip_fields :name

  def to_s
    name
  end
end
