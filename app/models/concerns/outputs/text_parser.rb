module Outputs::TextParser
  extend ActiveSupport::Concern

  def parse_and_find_lines_with_error
    return [] if text.blank?

    body = trigger.callback
    text.split("\n").map do |line|
      n = line.match(/\(eval\):(\d+)/)&.captures&.first&.to_i

      if n && n > 4
        # -4 lines of `code` header
        callback_line_number = n.to_i - 4
        callback_body        = body.split("\n")

        {
          error: callback_body[callback_line_number - 1].strip,
          line:  callback_line_number
        }
      end
    end.compact.uniq
  end

  def still_valid?
    trigger.updated_at < created_at
  end
end
