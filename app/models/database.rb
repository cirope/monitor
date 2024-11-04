# frozen_string_literal: true

class Database < ApplicationRecord
  include Attributes::Strip
  include Databases::AdapterDrivers
  include Databases::OrmConfig
  include Databases::ActiveRecordConfig
  include Databases::PonyConfig
  include Databases::Credentials
  include Databases::Odbc
  include Databases::Properties
  include Databases::Scopes
  include Databases::Search
  include Databases::SqlalchemyConfig
  include Databases::Validations
  include Filterable
  include PublicAuditable

  scope :ordered, -> { order :name }

  strip_fields :name

  belongs_to :account

  def to_s
    name
  end
end
