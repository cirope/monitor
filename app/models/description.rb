class Description < ActiveRecord::Base
  include Auditable
  include Descriptions::Validation

  belongs_to :script
end
