class Issue < ActiveRecord::Base
  include Auditable
  include Issues::Comments
  include Issues::Notifications
  include Issues::Status
  include Issues::Subscriptions
  include Issues::Validation
  include Taggable

  belongs_to :run
  has_many :users, through: :subscriptions

  def to_s
    run.to_s
  end
end
