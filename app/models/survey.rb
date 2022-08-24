# frozen_string_literal: true

class Survey < ApplicationRecord
  has_many :survey_answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  belongs_to :issue
  has_many :post_controls, as: :controllable, dependent: :destroy
  has_many :pre_controls, as: :controllable, dependent: :destroy

  accepts_nested_attributes_for :questions, :pre_controls, :post_controls

  def can_create_survey_answer?
    pre_controls.detect { |pre_control| pre_control.control(survey: self).error? }.blank?
  end

  def create_survey_answer
    survey_answer        = SurveyAnswer.new
    survey_answer.survey = self

    questions.each do |question|
      survey_answer.answers << question.create_answer
    end

    survey_answer
  end

  def post_control_survey_answer survey_answer
    post_controls.each { |post_control| post_control.control survey_answer: survey_answer }
  end
end
