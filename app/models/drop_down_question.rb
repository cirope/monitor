# frozen_string_literal: true

class DropDownQuestion < Question
  has_many :drop_down_options, foreign_key: 'question_id', dependent: :destroy

  accepts_nested_attributes_for :drop_down_options

  def create_answer
    drop_down_answer          = DropDownAnswer.new
    drop_down_answer.question = self

    drop_down_answer
  end

  def results
    initialize_hash_with_options.merge(collect_results)
                                .sort_by { |_k, v| v }
                                .reverse
  end

  def group_by_and_sum_scores
    initialize_hash_with_options.merge(collect_group_by_and_sum_scores)
                                .sort_by { |_k, v| v }
                                .reverse
  end

  def count_answers
    DropDownAnswer.left_joins(:drop_down_option)
                  .where(question_id: id)
                  .count
  end

  def sum_scores
    DropDownAnswer.left_joins(:drop_down_option)
                  .where(question_id: id)
                  .sum(:score)
  end

  def results_partial
    'drop_down_question'
  end

  private

    def collect_results
      DropDownAnswer.left_joins(:drop_down_option)
                    .where(question_id: id)
                    .group("#{DropDownOption.table_name}.value")
                    .count
    end

    def collect_group_by_and_sum_scores
      DropDownAnswer.left_joins(:drop_down_option)
                    .where(question_id: id)
                    .group("#{DropDownOption.table_name}.value")
                    .sum(:score)
    end

    def initialize_hash_with_options
      drop_down_options.each_with_object({}) { |drop_down_option, hsh| hsh[drop_down_option.value] = 0 }
    end
end
