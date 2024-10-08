# frozen_string_literal: true

class Issue < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include DataCasting
  include Exportable
  include Issues::CanonicalData
  include Issues::Cleanup
  include Issues::Comments
  include Issues::Csv
  include Issues::DataType
  include Issues::Export
  include Issues::GroupedExport
  include Issues::Notifications
  include Issues::Pdf
  include Issues::Permissions
  include Issues::Reminders
  include Issues::Scopes
  include Issues::Status
  include Issues::Subscriptions
  include Issues::StateTransitions
  include Issues::Tickets
  include Issues::Validation
  include Issues::Url
  include Issues::Views
  include Filterable
  include Taggable

  strip_fields :title

  belongs_to :owner, polymorphic: true, optional: true
  has_one :self_reference, class_name: 'Issue', foreign_key: :id
  has_one :run, through: :self_reference, source: :owner, source_type: 'Run'
  has_one :script, through: :run
  has_one :schedule, through: :run
  has_many :users, through: :subscriptions
  has_many :descriptions, through: :script
  has_and_belongs_to_many :permalinks

  def to_s
    title || script.to_s
  end
end
