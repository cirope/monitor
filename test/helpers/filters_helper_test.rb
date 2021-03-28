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
end
