# frozen_string_literal: true

class Fail < ApplicationRecord
  include Fail::Request

  validates :data, presence: true

  belongs_to :user, optional: true
end
