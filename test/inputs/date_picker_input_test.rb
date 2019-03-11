# frozen_string_literal: true

require 'test_helper'

class DatePickerInputTest < ActionView::TestCase
  test 'input' do
    simple_fields_for(Schedule.new) do |f|
      input = f.input :start, as: :date_picker

      assert_match /data-date-picker/, input
    end
  end
end
