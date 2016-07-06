require 'test_helper'

class RuleTest < ActiveSupport::TestCase
  setup do
    @rule = rules :cd_email
  end

  test 'blank attributes' do
    @rule.name = ''

    assert @rule.invalid?
    assert_error @rule, :name, :blank
  end

  test 'search' do
    rules = Rule.search query: @rule.name

    assert rules.present?
    assert rules.all? { |s| s.name =~ /#{@rule.name}/ }
  end

  test 'by name' do
    skip
  end
end
