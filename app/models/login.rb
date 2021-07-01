# frozen_string_literal: true

class Login < ApplicationRecord
  include Filterable
  include Logins::Request
  include Logins::Scopes

  belongs_to :user

  def to_s
    "#{user} - #{I18n.l created_at, format: :compact}"
  end
end
