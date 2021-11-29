# frozen_string_literal: true

class TextQuestion < Question
  MESS = 'SYSTEM ERROR: method missing'

  def create_answer
    text_answer          = TextAnswer.new
    text_answer.question = self

    text_answer
  end

  # def create_question
  #   self.new
  # end

  def results
    answers.map { |text_answer| text_answer.response_text }
  end

  def results_partial
    'text_question'
  end
end
