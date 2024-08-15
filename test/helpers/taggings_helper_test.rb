# frozen_string_literal: true

require 'test_helper'

class TaggingsHelperTest < ActionView::TestCase
  test 'tagging tags' do
    parent = tags :important
    child  = tags :final

    child.update! parent: parent

    assert_equal [[child.name, child.id]], tagging_tags(parent.name)
  end
end
