# frozen_string_literal: true

require 'test_helper'

class DescriptionTest < ActiveSupport::TestCase
  setup do
    @description = descriptions :ls_author
  end

  test 'blank attributes' do
    @description.name = ''
    @description.value = ''

    assert @description.invalid?
    assert_error @description, :name, :blank
    assert_error @description, :value, :blank
  end

  test 'attributes length' do
    @description.name = 'abcde' * 52

    assert @description.invalid?
    assert_error @description, :name, :too_long, count: 255
  end

  test 'attributes format' do
    @description.name = 'with } invalid char =)'
    @description.value = 'with } invalid char =)'

    assert @description.invalid?
    assert_error @description, :name, :invalid
    assert_error @description, :value, :invalid
  end
end
