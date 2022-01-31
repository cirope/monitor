# frozen_string_literal: true

class Issue < ApplicationRecord
  include Auditable
  include DataCasting
  include Exportable
  include Issues::Comments
  include Issues::ConvertedDataHash
  include Issues::Csv
  include Issues::DataType
  include Issues::Export
  include Issues::GroupedExport
  include Issues::Notifications
  include Issues::Pdf
  include Issues::Permissions
  include Issues::Scopes
  include Issues::Status
  include Issues::Subscriptions
  include Issues::StateTransitions
  include Issues::Validation
  include Issues::Url
  include Filterable
  include Taggable

  belongs_to :run
  has_one :script, through: :run
  has_one :schedule, through: :run
  has_many :users, through: :subscriptions
  has_and_belongs_to_many :permalinks

  def to_s
    script.to_s
  end
end
