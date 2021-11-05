# frozen_string_literal: true

class DropDownOption < ApplicationRecord
  validates :value, presence: true

  belongs_to :question
end
