# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :survey_answer
  belongs_to :question
end
