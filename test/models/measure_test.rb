# frozen_string_literal: true

require 'test_helper'

class MeasureTest < ActiveSupport::TestCase
  setup do
    @measure = measures :live_ls_measure
  end

  test 'create' do
    assert_difference 'Measure.count' do
      Measure.create measureable: executions(:live_ls), cpu: 3, memory_in_kb: 10000
    end
  end
end
