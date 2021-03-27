# frozen_string_literal: true

require 'test_helper'

class ParameterTest < ActiveSupport::TestCase
  setup do
    @parameter = parameters :ls_dir
  end

  test 'blank attributes' do
    @parameter.name = ''
    @parameter.value = ''

    assert @parameter.invalid?
    assert_error @parameter, :name, :blank
    assert_error @parameter, :value, :blank
  end

  test 'attributes length' do
    @parameter.name = 'abcde' * 52

    assert @parameter.invalid?
    assert_error @parameter, :name, :too_long, count: 255
  end

  test 'attributes format' do
    @parameter.name = 'with ] invalid char =)'
    @parameter.value = 'with ] invalid char =)'

    assert @parameter.invalid?
    assert_error @parameter, :name, :invalid
    assert_error @parameter, :value, :invalid
  end

  test 'unique attributes' do
    parameter = @parameter.dup

    assert parameter.invalid?
    assert_error parameter, :name, :taken
  end
end
