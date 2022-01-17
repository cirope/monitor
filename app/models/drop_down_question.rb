# frozen_string_literal: true

class DropDownQuestion < Question
  has_many :drop_down_options, foreign_key: 'question_id'

  MESS = 'SYSTEM ERROR: method missing'

  def create_answer
    drop_down_answer          = DropDownAnswer.new
    drop_down_answer.question = self

    drop_down_answer
  end

  # def create_question
  #   self.new
  # end

  def results
    initialize_hash_with_options.merge(collect_results)
  end

  def collect_results
    DropDownAnswer.left_joins(:drop_down_option)
                  .where(question_id: id)
                  .group("#{DropDownOption.table_name}.value")
                  .count
  end

  def initialize_hash_with_options
    drop_down_options.each_with_object({}) { |drop_down_option, hsh| hsh[drop_down_option.value] = 0 }
  end

  def results_partial
    'drop_down_question'
  end
end
