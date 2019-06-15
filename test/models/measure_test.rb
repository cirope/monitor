# frozen_string_literal: true

require 'test_helper'

class MeasureTest < ActiveSupport::TestCase
  setup do
    @measure = measures :live_ls_measure
  end

  test 'blank attributes' do
    @measure.cpu             = nil
    @measure.memory_in_bytes = nil

    assert @measure.invalid?
    assert_error @measure, :cpu, :blank
    assert_error @measure, :memory_in_bytes, :blank
  end

  test 'bounded attributes' do
    @measure.cpu             = 10000
    @measure.memory_in_bytes = 9_223_372_036_854_775_808

    assert @measure.invalid?
    assert_error @measure, :cpu, :less_than_or_equal_to, count: 9999.9
    assert_error @measure, :memory_in_bytes, :less_than_or_equal_to,
      count: 9_223_372_036_854_775_807

    @measure.cpu             = -1
    @measure.memory_in_bytes = -1

    assert @measure.invalid?
    assert_error @measure, :cpu, :greater_than_or_equal_to, count: 0
    assert_error @measure, :memory_in_bytes, :greater_than_or_equal_to, count: 0
  end

  test 'create' do
    assert_difference 'Measure.count' do
      Measure.create(
        measurable:      executions(:live_ls),
        cpu:             3,
        memory_in_bytes: 23000
      )
    end
  end
end
