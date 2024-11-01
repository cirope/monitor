# frozen_string_literal: true

require 'test_helper'

class ScriptShellTest < ActiveSupport::TestCase
  setup do
    @script = scripts :pwd
  end

  teardown do
    Current.account = nil
  end

  test 'body dependencies' do
    body = @script.body

    assert_match "require 'open3'", body
  end

  test 'body final text' do
    body = @script.body

    assert_match 'pwd', body
  end
end
