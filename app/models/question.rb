# frozen_string_literal: true

class Question < ApplicationRecord
  validates :title, presence: true

  belongs_to :survey
  has_many :answers

  MESS = 'SYSTEM ERROR: method missing'

  def create_answer
    raise MESS
  end

  def results
    raise MESS
  end
end
