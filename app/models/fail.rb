# frozen_string_literal: true

class Fail < ApplicationRecord
  include Fail::Request

  belongs_to :user, optional: true

  validates :data, presence: true
end
