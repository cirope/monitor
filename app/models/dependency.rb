# frozen_string_literal: true

class Dependency < ApplicationRecord
  include Auditable

  validates :schedule, presence: true

  belongs_to :dependent, class_name: 'Schedule', optional: true
  belongs_to :schedule
end
