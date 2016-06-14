class Database < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include Databases::Credentials
  include Databases::Odbc
  include Databases::Properties
  include Databases::Validations

  scope :ordered, -> { order :name }

  strip_fields :name

  def to_s
    name
  end
end
