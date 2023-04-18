# frozen_string_literal: true

class Rule < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Exportable
  include Filterable
  include SearchableByName
  include Rules::Export
  include Rules::Import
  include Rules::Json
  include Rules::Scopes
  include Rules::Triggers
  include Ticketable

  validates :name, presence: true

  scope :ordered, -> { order :name }

  has_many :dispatchers, dependent: :nullify

  strip_fields :name

  def to_s
    name
  end
end
