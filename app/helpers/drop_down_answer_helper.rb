# frozen_string_literal: true

module DropDownAnswerHelper
  def drop_down_options drop_down_question
    drop_down_question.drop_down_options.map do |option|
      ["#{option.value} (score: #{option.score})", option.id]
    end
  end
end
