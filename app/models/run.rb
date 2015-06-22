class Run < ActiveRecord::Base
  include Runs::Validation

  belongs_to :schedule
end
