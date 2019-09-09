# frozen_string_literal: true

require 'test_helper'

class OutputTest < ActiveSupport::TestCase
  setup do
    @output = outputs :email_output
  end

  test 'blank attributes' do
    @output.run = nil

    assert @output.invalid?
    assert_error @output, :run, :blank
  end
end
