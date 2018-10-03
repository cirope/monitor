class Rule < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Filterable
  include SearchableByName
  include Rules::Export
  include Rules::Import
  include Rules::JSON
  include Rules::Scopes
  include Rules::Triggers

  validates :name, presence: true

  scope :ordered, -> { order :name }

  has_many :dispatchers, dependent: :destroy

  strip_fields :name

  def to_s
    name
  end
end
