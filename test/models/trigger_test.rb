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

  test 'run on' do
    skip
  end
end
