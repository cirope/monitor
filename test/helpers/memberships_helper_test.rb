require 'test_helper'

class MembershipsHelperTest < ActionView::TestCase
  test 'link to default' do
    @virtual_path = 'memberships.membership'

    membership = send 'public.memberships', :franco_default

    assert_match t('.default'), link_to_default(membership)

    membership.update! default: false

    assert_match t('.make_default'), link_to_default(membership)
  end

  test 'link to switch' do
    @virtual_path = 'memberships.membership'

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
