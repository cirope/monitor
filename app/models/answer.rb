# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :survey_answer
  belongs_to :question
  has_one :survey, through: :survey_answer

  after_save :post_control_answer

  private

    def post_control_answer
      question.post_control_answer self
    end
end
