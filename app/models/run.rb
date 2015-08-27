class Run < ActiveRecord::Base
  include Runs::Schedule
  include Runs::Status
  include Runs::Validation

  belongs_to :job
  has_one :script, through: :job
  has_one :server, through: :job
  has_one :schedule, through: :job
end
