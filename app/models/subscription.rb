class Subscription < ApplicationRecord
  include Auditable
  include Subscriptions::Validation

  belongs_to :issue
  belongs_to :user

  def to_s
    "#{user} -> #{issue}"
  end
end
