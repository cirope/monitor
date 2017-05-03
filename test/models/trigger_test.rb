require 'test_helper'

class TriggerTest < ActiveSupport::TestCase
  setup do
    @trigger = triggers :email
  end

  test 'blank attributes' do
    @trigger.callback = ''

    assert @trigger.invalid?
    assert_error @trigger, :callback, :blank
  end

  test 'code attributes' do
    error = '<compiled>:1: syntax error, unexpected end-of-input, expecting keyword_end'

    @trigger.callback = 'def x; true; en'

    assert @trigger.invalid?
    assert_error @trigger, :callback, :syntax, errors: error
  end

  test 'run on' do
    skip
  end
end
