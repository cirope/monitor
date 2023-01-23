# frozen_string_literal: true

require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  setup do
    @permission = permissions :supervisor
  end

  test 'blank attributes' do
    @permission.section = ''

    assert @permission.invalid?
    assert_error @permission, :section, :blank
  end

  test 'unique attributes' do
    permission = @permission.dup

    assert permission.invalid?
    assert_error permission, :section, :taken
  end

  test 'included attributes' do
    @permission.section = 'wrong'

    assert @permission.invalid?
    assert_error @permission, :section, :inclusion
  end
end
