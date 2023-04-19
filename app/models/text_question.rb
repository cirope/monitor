# frozen_string_literal: true

class TextQuestion < Question
  def create_answer
    text_answer          = TextAnswer.new
    text_answer.question = self

    text_answer
  end

  def results
    answers.map(&:response_text)
  end

  def results_partial
    'text_question'
  end
end
