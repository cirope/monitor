# frozen_string_literal: true

class Comment < ApplicationRecord
  include Auditable
  include Comments::Destroy
  include Comments::Notify
  include Comments::Owner
  include Comments::Validation

  has_one_attached :attachment

  belongs_to :issue
  belongs_to :ticket, foreign_key: "issue_id"
  has_many :users, through: :issue
  has_many :users, through: :ticket

  def to_s
    text
  end
end
