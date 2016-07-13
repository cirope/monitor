class Output < ApplicationRecord
  include Auditable
  include Outputs::Validation

  belongs_to :trigger
  belongs_to :run
end
