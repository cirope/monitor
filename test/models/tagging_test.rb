require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  def setup
    @tagging = taggings :cd_root_as_starter
  end

  test 'blank attributes' do
    @tagging.tag = nil

    assert @tagging.invalid?
    assert_error @tagging, :tag, :blank
  end
end
