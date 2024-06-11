# frozen_string_literal: true

class Run < ApplicationRecord
  include DataCasting
  include Filterable
  include Killable
  include Measurable
  include Runs::Cleanup
  include Runs::Defaults
  include Runs::Execution
  include Runs::Notifications
  include Runs::Scopes
  include Runs::Status
  include Runs::Validation
  include Runs::Triggers
  include Outputs::Parser
  include Outputs::Status

  belongs_to :job
  belongs_to :script
  belongs_to :server
  has_one :schedule, through: :job
  has_many :dispatchers, through: :schedule
  has_many :issues, as: :owner, dependent: :restrict_with_error
  has_many :outputs, dependent: :destroy
  has_many :users, through: :issues

  def to_s
    "#{schedule} (#{I18n.l scheduled_at, format: :short})"
  end

  def language
    'ruby'
  end
end
