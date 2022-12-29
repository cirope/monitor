# frozen_string_literal: true

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  setup do
    @role = roles :one
  end

  test 'blank attributes' do
    @role.attr = ''

    assert @role.invalid?
    assert_error @role, :attr, :blank
  end

  test 'unique attributes' do
    role = @role.dup

    assert role.invalid?
    assert_error role, :attr, :taken
  end
end
