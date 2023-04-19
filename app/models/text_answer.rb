# frozen_string_literal: true

class TextAnswer < Answer
  validates :response_text, presence: true

  def partial
    'text_answer'
  end
end
