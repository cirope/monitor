# frozen_string_literal: true

require 'test_helper'

class FiltersHelperTest < ActionView::TestCase
  test 'filters?' do
    assert !filters?

    params[:filter] = { name: '  ' }

    assert !filters?

    params[:filter] = { name: 'something' }

    assert filters?
  end

  test 'dashboard empty message' do
    @virtual_path = 'dashboards.index'

    assert_kind_of String, empty_message
  end

  test 'should return is not start row in data filter' do
    refute start_row_in_data_filter(1)
  end

  test 'should return is start row in data filter' do
    assert start_row_in_data_filter(0)
  end

  test 'should return is not end row in data filter' do
    @data_keys = ['key 1', 'key 2', 'key 3', 'key 4']

    refute end_row_in_data_filter(0)
  end

  test 'should return is end row in data filter' do
    @data_keys = ['key 1', 'key 2', 'key 3', 'key 4']

    assert end_row_in_data_filter(2)

    assert end_row_in_data_filter(3)
  end
end
