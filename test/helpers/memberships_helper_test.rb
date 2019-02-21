require 'test_helper'

class MembershipsHelperTest < ActionView::TestCase
  test 'link to switch' do
    @virtual_path = 'memberships.index'

    membership = send 'public.memberships', :franco_default

    assert_match t('navigation.switch'), link_to_switch(membership)

    set_account

    assert_match t('.current'), link_to_switch(membership)
  end

  private

    def current_account
      @current_account
    end

    def set_account account = send('public.accounts', :default)
      @current_account = account
    end
end
