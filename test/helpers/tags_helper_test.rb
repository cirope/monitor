require 'test_helper'

class TagsHelperTest < ActionView::TestCase
  test 'tag_kinds' do
    assert_respond_to tag_kinds, :each
  end

  test 'styles' do
    assert_respond_to styles, :each
  end

  test 'tags' do
    _tags  = scripts(:cd_root).tags
    result = tags _tags

    assert_match _tags.first.name, result
  end
end
