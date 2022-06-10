# frozen_string_literal: true

require 'test_helper'

class DropDownQuestionTest < ActiveSupport::TestCase
  setup do
    @drop_down_question = questions :drop_down_question_survey_for_ls_on_atahualpa_not_well
  end

  test 'should create answer' do
    drop_down_answer = @drop_down_question.create_answer

    assert drop_down_answer.new_record?
    assert_equal drop_down_answer.question, @drop_down_question
    assert_instance_of DropDownAnswer, drop_down_answer
  end

  test 'should return results' do
    results_without_blanks = DropDownAnswer.left_joins(:drop_down_option)
                                           .where(question_id: @drop_down_question.id)
                                           .group("#{DropDownOption.table_name}.value")
                                           .count

    expected = initialize_hash_with_options.merge(results_without_blanks)
                                           .sort_by { |_k, v| v }
                                           .reverse

    assert_equal expected, @drop_down_question.results
  end

  test 'should return group by and sum scores' do
    results_without_blanks = DropDownAnswer.left_joins(:drop_down_option)
                                           .where(question_id: @drop_down_question.id)
                                           .group("#{DropDownOption.table_name}.value")
                                           .sum(:score)

    expected = initialize_hash_with_options.merge(results_without_blanks)
                                           .sort_by { |_k, v| v }
                                           .reverse

    assert_equal expected, @drop_down_question.group_by_and_sum_scores
  end

  test 'should return count_answers' do
    expected = DropDownAnswer.left_joins(:drop_down_option)
                             .where(question_id: @drop_down_question.id)
                             .count

    assert_equal expected, @drop_down_question.count_answers
  end

  test 'should return sum scores' do
    expected = DropDownAnswer.left_joins(:drop_down_option)
                             .where(question_id: @drop_down_question.id)
                             .sum(:score)

    assert_equal expected, @drop_down_question.sum_scores
  end

  test 'should return results partial' do
    assert_equal 'drop_down_question', @drop_down_question.results_partial
  end

  private

    def initialize_hash_with_options
      drop_down_options.each_with_object({}) { |drop_down_option, hsh| hsh[drop_down_option.value] = 0 }
    end
end
