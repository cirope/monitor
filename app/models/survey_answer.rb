# frozen_string_literal: true

class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  has_many :answers, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :answers
end
