class Output < ActiveRecord::Base
  include Auditable
  include Outputs::Validation

  belongs_to :trigger
  belongs_to :run
end
