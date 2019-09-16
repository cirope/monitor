# frozen_string_literal: true

class Database < ApplicationRecord
  include Attributes::Strip
  include Databases::ActiveRecordConfig
  include Databases::Credentials
  include Databases::ODBC
  include Databases::Properties
  include Databases::Scopes
  include Databases::Search
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
