require 'test_helper'

class MaintainerTest < ActiveSupport::TestCase
  setup do
    @maintainer = maintainers :cd_root_author
  end

  test 'blank attributes' do
    @maintainer.user = nil

    assert @maintainer.invalid?
    assert_error @maintainer, :user, :blank
  end
end
