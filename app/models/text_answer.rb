# frozen_string_literal: true

class TextAnswer < Answer
  validates :response_text, presence: true
end
