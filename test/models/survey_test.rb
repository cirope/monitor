# frozen_string_literal: true

require 'test_helper'

class SurveyTest < ActiveSupport::TestCase
  setup do
    @survey = surveys :survey_for_ls_on_atahualpa_not_well
  end

  test 'create survey answer' do
    survey_answer = @survey.create_survey_answer

    assert_instance_of SurveyAnswer, survey_answer
    assert_equal survey_answer.survey, @survey
    assert_equal survey_answer.answers.length, @survey.questions.count
  end
end
