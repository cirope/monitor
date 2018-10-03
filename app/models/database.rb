class Database < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Databases::ActiveRecordConfig
  include Databases::Credentials
  include Databases::ODBC
  include Databases::Properties
  include Databases::Scopes
  include Databases::Validations
  include Filterable

  scope :ordered, -> { order :name }

  strip_fields :name

  def to_s
    name
  end
end
