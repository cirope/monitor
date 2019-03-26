# frozen_string_literal: true

class Run < ApplicationRecord
  include Filterable
  include Runs::Execution
  include Runs::Scopes
  include Runs::Status
  include Runs::Validation
  include Runs::Triggers
  include Outputs::Parser

  belongs_to :job
  has_one :script, through: :job
  has_one :server, through: :job
  has_one :schedule, through: :job
  has_many :dispatchers, through: :schedule
  has_many :issues, dependent: :restrict_with_error
  has_many :outputs, dependent: :destroy

  def to_s
    "#{schedule} (#{I18n.l scheduled_at, format: :short})"
  end
end
