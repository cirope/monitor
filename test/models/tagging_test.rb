require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  setup do
    @tagging = taggings :cd_root_as_starter
  end

  test 'blank attributes' do
    @tagging.tag = nil

    assert @tagging.invalid?
    assert_error @tagging, :tag, :blank
  end

  test 'unique attributes' do
    tagging = @tagging.dup

    assert tagging.invalid?
    assert_error tagging, :tag_id, :taken
  end
end
