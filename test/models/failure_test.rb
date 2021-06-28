# frozen_string_literal: true

require 'test_helper'

class FailureTest < ActiveSupport::TestCase
  setup do
    @failure = failures :one
  end

  test 'blank attributes' do
    @failure.attr = ''

    assert @failure.invalid?
    assert_error @failure, :attr, :blank
  end

  test 'unique attributes' do
    failure = @failure.dup

    assert failure.invalid?
    assert_error failure, :attr, :taken
  end
end
