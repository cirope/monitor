require 'test_helper'

class RulesHelperTest < ActionView::TestCase
  test 'rule triggers' do
    @rule = rules :cd_email

    assert_equal @rule.triggers, triggers

    @rule = Rule.new

    assert_equal 1, triggers.size
    assert triggers.all?(&:new_record?)
  end
end
