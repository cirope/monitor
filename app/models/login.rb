# frozen_string_literal: true

class Login < ApplicationRecord
  include Logins::Request

  belongs_to :user

  def to_s
    "#{user} - #{I18n.l created_at, format: :compact}"
  end
end
