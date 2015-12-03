require 'test_helper'

class DescriptionTest < ActiveSupport::TestCase
  def setup
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
    @description.value = 'abcde' * 52

    assert @description.invalid?
    assert_error @description, :name, :too_long, count: 255
    assert_error @description, :value, :too_long, count: 255
  end
end
