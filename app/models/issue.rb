class Issue < ActiveRecord::Base
  include Auditable
  include Issues::Comments
  include Issues::Notifications
  include Issues::Scopes
  include Issues::Status
  include Issues::Subscriptions
  include Issues::Validation
  include Filterable
  include Taggable

  belongs_to :run
  has_one :script, through: :run
  has_many :users, through: :subscriptions
  has_and_belongs_to_many :permalinks

  def to_s
    script.to_s
  end
end
