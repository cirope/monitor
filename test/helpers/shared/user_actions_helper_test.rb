# frozen_string_literal: true

require 'test_helper'

class Shared::UserActionsHelperTest < ActionView::TestCase
  test 'Should return badge to supervisor role' do
    supervisor = users :franco

    assert_equal role_badge(supervisor.role), 'bg-success'
  end

  test 'Should return badge to guest role' do
    supervisor = users :john

    assert_equal role_badge(supervisor.role), 'bg-light text-dark'
  end

  test 'Should return badge to author role' do
    supervisor = users :eduardo

    assert_equal role_badge(supervisor.role), 'bg-info'
  end

  test 'Should return badge to security role' do
    supervisor = users :god

    assert_equal role_badge(supervisor.role), 'bg-danger'
  end

  test 'Should return badge to manager role' do
    manager = users :franco

    manager.role = Role.find_by type: 'manager'

    assert_equal role_badge(manager.role), 'bg-secondary'
  end

  test 'Should return badge to owner role' do
    owner = users :franco

    owner.role = Role.find_by type: 'owner'

    assert_equal role_badge(owner.role), 'bg-primary'
  end
end
