class Run < ActiveRecord::Base
  include Runs::Schedule
  include Runs::Status
  include Runs::Validation

  belongs_to :schedule
end
