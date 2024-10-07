# frozen_string_literal: true

require 'test_helper'

class VariableTest < ActiveSupport::TestCase
  setup do
    @variable = variables :variable
  end

  test 'blank attributes' do
    @variable.name  = ''
    @variable.value = ''

    assert @variable.invalid?
    assert_error @variable, :name, :blank
    assert_error @variable, :value, :blank
  end

  test 'attributes length' do
    @variable.name = 'abcde' * 52

    assert @variable.invalid?
    assert_error @variable, :name, :too_long, count: 255
  end

  test 'attributes format' do
    @variable.name  = 'with ] invalid char =)'
    @variable.value = 'with ] invalid char =)'

    assert @variable.invalid?
    assert_error @variable, :name, :invalid
    assert_error @variable, :value, :invalid
  end

  test 'unique attributes' do
    variable = @variable.dup

    assert variable.invalid?
    assert_error variable, :name, :taken
  end
end
