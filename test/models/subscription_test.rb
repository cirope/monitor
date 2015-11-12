require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  def setup
    @subscription = subscriptions :franco_ls_on_atahualpa
  end

  test 'blank attributes' do
    @subscription.user = nil

    assert @subscription.invalid?
    assert_error @subscription, :user, :blank
  end
end
