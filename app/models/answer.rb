# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :survey_answer
  belongs_to :question
  has_one :survey, through: :survey_answer

  after_commit :control_answer

  private

    def control_answer
      survey.control_answer self
    end
end
