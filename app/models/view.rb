# frozen_string_literal: true

class View < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  def self.viewed_by user
    where user_id: user.id
  end
end
