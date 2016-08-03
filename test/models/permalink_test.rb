require 'test_helper'

class PermalinkTest < ActiveSupport::TestCase
  setup do
    @permalink = permalinks :link
  end

  test 'blank attributes' do
    @permalink.token = ''

    assert @permalink.invalid?
    assert_error @permalink, :token, :blank
  end

  test 'unique attributes' do
    permalink = @permalink.dup

    assert permalink.invalid?
    assert_error permalink, :token, :taken
  end
end
