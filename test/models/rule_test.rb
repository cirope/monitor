require 'test_helper'

class RuleTest < ActiveSupport::TestCase
  def setup
    @rule = rules :cd_email
  end

  test 'blank attributes' do
    @rule.name = ''

    assert @rule.invalid?
    assert_error @rule, :name, :blank
  end
end
