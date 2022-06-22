# frozen_string_literal: true

require 'test_helper'

class SurveyTest < ActiveSupport::TestCase
  setup do
    @survey = surveys :survey_for_ls_on_atahualpa_not_well
  end

  test 'can create survey answer' do
    assert_difference 'ControlOutput.count' do
      assert @survey.can_create_survey_answer?
    end
  end

  test 'cannot create survey answer' do
    @survey.pre_controls << PreControl.new(callback: "raise 'this is an error'")

    assert_difference 'ControlOutput.count', 2 do
      refute @survey.can_create_survey_answer?
    end
  end

  test 'create survey answer' do
    survey_answer = @survey.create_survey_answer

    assert_instance_of SurveyAnswer, survey_answer
    assert_equal survey_answer.survey, @survey
    assert_equal survey_answer.answers.length, @survey.questions.count
  end

  test 'execute post control survey answer and update issue from survey' do
    @survey.post_controls
           .first
           .update_attribute :callback, "survey.issue.update_attribute(:description, 'test')"

    assert_difference 'ControlOutput.count' do
      @survey.post_control_survey_answer @survey.survey_answers.first
    end

    assert ControlOutput.last.ok?
    assert_equal 'test', @survey.issue.reload.description
  end
end
