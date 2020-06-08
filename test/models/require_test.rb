# frozen_string_literal: true

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

  test 'require can not be used twice' do
    dup_require = @require.dup

    assert dup_require.invalid?
    assert_error dup_require, :script, :taken
  end

  test 'require can not include core scripts' do
    @require.script.update! core: true

    assert @require.invalid?
    assert_error @require, :script, :taken
  end
end
