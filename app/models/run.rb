class Run < ActiveRecord::Base
  include Auditable
  include Runs::Schedule
  include Runs::Validation

  belongs_to :schedule
end
