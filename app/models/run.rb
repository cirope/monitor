class Run < ActiveRecord::Base
  include Runs::Schedule
  include Runs::Status
  include Runs::Validation
  include Runs::Triggers

  belongs_to :job
  has_one :script, through: :job
  has_one :server, through: :job
  has_one :schedule, through: :job
  has_many :issues, dependent: :destroy

  def to_s
    "#{schedule} (#{I18n.l scheduled_at, format: :short})"
  end
end
