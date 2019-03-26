# frozen_string_literal: true

class Maintainer < ApplicationRecord
  include Auditable

  validates :user, presence: true

  belongs_to :user
  belongs_to :script

  def to_s
    "#{user} -> #{script}"
  end
end
