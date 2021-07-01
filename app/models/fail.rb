# frozen_string_literal: true

class Fail < ApplicationRecord
  include Filterable
  include Fails::Request
  include Fails::Scopes

  validates :data, presence: true

  belongs_to :user, optional: true
end
