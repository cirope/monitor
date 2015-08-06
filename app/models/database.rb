class Database < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include Databases::Validations
  include Databases::Odbc
  include Databases::Properties

  scope :ordered, -> { order :name }

  strip_fields :name

  def to_s
    name
  end
end
