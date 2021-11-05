# frozen_string_literal: true

class Survey < ApplicationRecord
  has_many :survey_answers
  has_many :questions

  def create_survey_answer
    survey_answer        = SurveyAnswer.new
    survey_answer.survey = self

    questions.each do |question|
      survey_answer.answers << question.create_answer
    end

    survey_answer
  end
end
