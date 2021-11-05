# frozen_string_literal: true

class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  has_many :answers
end
