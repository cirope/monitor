require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  setup do
    @property = send 'public.properties', :trace
  end

  test 'blank attributes' do
    @property.key = ''
    @property.value = ''

    assert @property.invalid?
    assert_error @property, :key, :blank
    assert_error @property, :value, :blank
  end

  test 'attributes length' do
    @property.key = 'abcde' * 52
    @property.value = 'abcde' * 52

    assert @property.invalid?
    assert_error @property, :key, :too_long, count: 255
    assert_error @property, :value, :too_long, count: 255
  end

  test 'password' do
    assert !@property.password?

    @property.key = 'passwd'

    assert @property.password?
  end
end
