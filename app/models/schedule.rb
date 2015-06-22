class Schedule < ActiveRecord::Base
  include Schedules::Validation

  belongs_to :script
  belongs_to :server
  has_many :runs, dependent: :destroy

  def to_s
    [script, server].join(' -> ')
  end
end
