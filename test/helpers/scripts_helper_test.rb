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

    assert_equal @script.taggings, script_taggings

    @script = Script.new

    assert_equal 1, script_taggings.size
    assert script_taggings.all?(&:new_record?)
  end

  test 'script parameters' do
    @script = scripts :ls

    assert_equal @script.parameters, parameters

    @script = Script.new

    assert_equal 1, parameters.size
    assert parameters.all?(&:new_record?)
  end

  test 'script descriptions' do
    @script = scripts :ls

    assert_equal @script.descriptions, descriptions

    @script = Script.new

    assert_equal 1, descriptions.size
    assert descriptions.all?(&:new_record?)
  end

  test 'file identifier' do
    skip
  end
end
