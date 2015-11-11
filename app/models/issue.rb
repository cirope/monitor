class Issue < ActiveRecord::Base
  include Auditable
  include Issues::Notifications
  include Issues::Status
  include Issues::Subscriptions
  include Issues::Validation

  belongs_to :run

  def to_s
    run.to_s
  end
end
