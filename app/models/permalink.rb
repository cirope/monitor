class Permalink < ApplicationRecord
  include Auditable
  include Permalinks::Defaults
  include Permalinks::Validation

  has_and_belongs_to_many :issues

  def to_param
    persisted? ? token : nil
  end
end
