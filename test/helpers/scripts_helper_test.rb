require 'test_helper'

class ScriptsHelperTest < ActionView::TestCase
  test 'script requires' do
    @script = scripts :ls

    assert_equal @script.requires, requires

    @script = Script.new

    assert_equal 1, requires.size
    assert requires.all?(&:new_record?)
  end

  test 'script taggings' do
    @script = scripts :ls

    assert_equal @script.taggings, taggings

    @script = Script.new

    assert_equal 1, taggings.size
    assert taggings.all?(&:new_record?)
  end

  test 'file identifier' do
    skip
  end
end
