require 'test_helper'

class DispatcherTest < ActiveSupport::TestCase
  setup do
    @dispatcher = dispatchers :cd_email
  end

  test 'blank attributes' do
    @dispatcher.rule = nil

    assert @dispatcher.invalid?
    assert_error @dispatcher, :rule, :blank
  end
end
