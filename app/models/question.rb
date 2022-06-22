# frozen_string_literal: true

class Question < ApplicationRecord
  validates :title, presence: true

  belongs_to :survey
  has_many :answers
  has_many :post_controls, as: :controllable, dependent: :destroy

  accepts_nested_attributes_for :post_controls

  MESS = 'SYSTEM ERROR: method missing'

  def create_answer
    raise MESS
  end

  def results
    raise MESS
  end

  def post_control_answer answer
    post_controls.each { |post_control| post_control.control answer: answer }
  end
end
