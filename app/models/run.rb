class Run < ActiveRecord::Base
  include Runs::Schedule
  include Runs::Validation

  belongs_to :schedule
end
