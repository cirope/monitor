class Issue < ApplicationRecord
  include Auditable
  include Issues::Comments
  include Issues::ExportData
  include Issues::Notifications
  include Issues::PDF
  include Issues::Permissions
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
