# frozen_string_literal: true

require 'test_helper'

class FailTest < ActiveSupport::TestCase
  setup do
    @fail = fails :fail_default
  end

  test 'Invalid fail without data' do
    @fail.data = ''

    assert @fail.invalid?
    assert_error @fail, :data, :blank
  end
end
