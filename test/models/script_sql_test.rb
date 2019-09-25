# frozen_string_literal: true

require 'test_helper'

class ScriptSqlTest < ActiveSupport::TestCase
  setup do
    @script = scripts :select_from_users
  end

  teardown do
    Current.account = nil
  end

  test 'validates database presence' do
    @script.database_id = nil

    assert @script.invalid?
    assert_error @script, :database, :blank
  end

  test 'body dependencies' do
    body = @script.body

    assert_match "require 'active_record'", body
    assert_match "require 'pg'", body
  end

  test 'body final text' do
    body = @script.body

    assert_match 'ActiveRecord::Base.establish_connection', body
    assert_match /puts pool\.connection\.exec_query\(.*\)\.to_a.to_json/, body
  end
end
