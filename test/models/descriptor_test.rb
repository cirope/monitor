require 'test_helper'

class DescriptorTest < ActiveSupport::TestCase
  setup do
    @descriptor = descriptors :author
  end

  test 'blank attributes' do
    @descriptor.name = ''

    assert @descriptor.invalid?
    assert_error @descriptor, :name, :blank
  end

  test 'unique attributes' do
    descriptor = @descriptor.dup

    assert descriptor.invalid?
    assert_error descriptor, :name, :taken
  end

  test 'attributes length' do
    @descriptor.name = 'abcde' * 52

    assert @descriptor.invalid?
    assert_error @descriptor, :name, :too_long, count: 255
  end
end
