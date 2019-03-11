# frozen_string_literal: true

require 'test_helper'

class ObjectsHelperTest < ActionView::TestCase
  test 'render object' do
    skip
  end

  test 'link or show' do
    skip
  end

  test 'can be graphed' do
    assert can_be_graphed?(one: 1, two: 2)
    assert !can_be_graphed?(name: 'John')
  end

  test 'graph container' do
    object = { one: 1, two: 2 }

    assert_match object.object_id.to_s, graph_container(object)
  end
end
