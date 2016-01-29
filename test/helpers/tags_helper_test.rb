require 'test_helper'

class TagsHelperTest < ActionView::TestCase
  test 'tag_kinds' do
    assert_respond_to tag_kinds, :each
  end
end
