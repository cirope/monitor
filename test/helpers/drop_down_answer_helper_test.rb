# frozen_string_literal: true

require 'test_helper'

class DropDownAnswerHelperTest < ActionView::TestCase
  test 'should return drop down options' do
    drop_down_question = questions :drop_down_question_survey_for_ls_on_atahualpa_not_well

    expected = drop_down_question.drop_down_options.map do |option|
      ["#{option.value} (score: #{option.score})", option.id]
    end

    assert_equal expected, drop_down_options(drop_down_question)
  end
end
