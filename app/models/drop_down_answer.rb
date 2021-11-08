# frozen_string_literal: true

class DropDownAnswer < Answer
  belongs_to :drop_down_option

  def partial
    'drop_down_answer'
  end
end
