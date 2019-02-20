require 'test_helper'

class MembershipsHelperTest < ActionView::TestCase
  test 'link to switch' do
    membership = send 'public.memberships', :franco_default

    assert_match t('navigation.switch'), link_to_switch(membership)

    set_account

    assert_nil link_to_switch(membership)
  end

  private

    def current_account
      @current_account
    end

    def set_account account = send('public.accounts', :default)
      @current_account = account
    end
end
