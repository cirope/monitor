# frozen_string_literal: true

require 'test_helper'

class SurveyAnswerTest < ActiveSupport::TestCase
  test 'invalid because refute pre controls survey' do
    survey = surveys :survey_for_ls_on_atahualpa_not_well
    user   = users :franco

    survey.pre_controls << PreControl.new(callback: "raise 'this is an error'")

    survey_answer = SurveyAnswer.new survey: survey, user: user

    refute survey_answer.valid?
    assert_error survey_answer, :base, :invalid_pre_controls
  end

  test 'execute post control survey answer when create' do
    survey = surveys :survey_for_ls_on_atahualpa_not_well
    user   = users :franco

    PostControl.create! controllable: survey, callback: "survey.issue.update_attribute(:description, 'test')"

    assert_difference 'ControlOutput.count', 3 do
      SurveyAnswer.create! survey: survey, user: user
    end

    survey.reload.post_controls.each do |pc|
      assert pc.control_outputs.all?(&:ok?)
    end

    assert_equal 'test', survey.issue.reload.description
  end
end
