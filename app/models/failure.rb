# frozen_string_literal: true

class Failure < ApplicationRecord
  include Failures::Request

  belongs_to :user, optional: true

  validates :data, presence: true
end
