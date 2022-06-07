# frozen_string_literal: true

class Survey < ApplicationRecord
  has_many :survey_answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  belongs_to :issue
  has_many :controls, dependent: :destroy

  accepts_nested_attributes_for :questions

  def create_survey_answer
    survey_answer        = SurveyAnswer.new
    survey_answer.survey = self

    questions.each do |question|
      survey_answer.answers << question.create_answer
    end

    survey_answer
  end

  def control_answer answer
    controls.each { |control| control.control_answer answer }
  end
end
