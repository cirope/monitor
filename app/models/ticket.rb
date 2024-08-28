# frozen_string_literal: true

class Ticket < Issue
  self.table_name = "issues"

 # has_many :subscriptions, foreign_key: "issue_id"
 # has_many :users, through: :subscriptions
 # has_many :comments, dependent: :destroy, foreign_key: "issue_id"
end
