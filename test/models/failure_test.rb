# frozen_string_literal: true

require 'test_helper'

class FailureTest < ActiveSupport::TestCase
  setup do
    @failure = failures :failure_default
  end

  test 'Invalid failure without data' do
    @failure.data = ''

    assert @failure.invalid?
    assert_error @failure, :data, :blank
  end

  test 'valid failure with data' do
    assert @failure.valid?
  end
end
