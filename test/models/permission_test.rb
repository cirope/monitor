# frozen_string_literal: true

require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  setup do
    @permission = permissions :one
  end

  test 'blank attributes' do
    @permission.attr = ''

    assert @permission.invalid?
    assert_error @permission, :attr, :blank
  end

  test 'unique attributes' do
    permission = @permission.dup

    assert permission.invalid?
    assert_error permission, :attr, :taken
  end
end
