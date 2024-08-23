# frozen_string_literal: true

class Ticket < ApplicationRecord
  self.table_name = "issues"

  include Issues::Tickets
  include Issues::Status
  include Issues::Comments
  include Issues::Validation
  include Issues::Scopes
  include Issues::Subscriptions
  include Issues::Permissions
  include Filterable
  include Taggable

  belongs_to :owner, polymorphic: true, optional: true
  has_many :subscriptions, foreign_key: "issue_id"
  has_one :script, through: :run
  has_many :users, through: :subscriptions
  has_many :descriptions, through: :script
  has_many :comments, dependent: :destroy, foreign_key: "issue_id"
end
