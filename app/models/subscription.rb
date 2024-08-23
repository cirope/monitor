# frozen_string_literal: true

class Subscription < ApplicationRecord
  include Auditable
  include Subscriptions::Validation

  belongs_to :issue
  belongs_to :ticket, foreign_key: "issue_id"
  belongs_to :user

  def to_s
    "#{user} -> #{issue}"
  end
end
