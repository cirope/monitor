# frozen_string_literal: true

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  setup do
    @role = roles :supervisor
  end

  test 'blank attributes' do
    @role.name = ''
    @role.description = ''

    assert @role.invalid?
    assert_error @role, :name, :blank
    assert_error @role, :description, :blank
  end

  test 'unique attributes' do
    role = @role.dup

    assert role.invalid?
    assert_error role, :name, :taken
    assert_error role, :identifier, :taken
  end

  test 'included attributes' do
    @role.type = 'wrong'

    assert @role.invalid?
    assert_error @role, :type, :inclusion
  end

  test 'guest?' do
    @role.type = 'guest'
    assert @role.guest?

    @role.type = 'author'
    assert !@role.guest?
  end
end
