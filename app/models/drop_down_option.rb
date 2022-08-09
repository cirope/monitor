# frozen_string_literal: true

class DropDownOption < ApplicationRecord
  validates :value, :score, presence: true

  belongs_to :question, optional: true
end
