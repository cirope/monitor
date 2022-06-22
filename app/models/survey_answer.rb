# frozen_string_literal: true

class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  has_many :answers, dependent: :destroy
  belongs_to :user

  after_save :post_control_survey_answer

  accepts_nested_attributes_for :answers

  validate :survey_pre_controls

  private

    def post_control_survey_answer
      survey.post_control_survey_answer self
    end

    def survey_pre_controls
      if !survey.can_create_survey_answer?
        errors.add :base, :invalid_pre_controls
      end
    end
end
