require 'test_helper'

class RequireTest < ActiveSupport::TestCase
  setup do
    @require = requires :cd_root_before_ls
  end

  test 'blank attributes' do
    @require.script = nil

    assert @require.invalid?
    assert_error @require, :script, :blank
  end
end
