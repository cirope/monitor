# frozen_string_literal: true

require 'test_helper'

class DatabaseTest < ActiveSupport::TestCase
  setup do
    @database = send 'public.databases', :postgresql
  end

  test 'blank attributes' do
    @database.name = ''
    @database.driver = ''
    @database.description = ''

    assert @database.invalid?
    assert_error @database, :name, :blank
    assert_error @database, :driver, :blank
    assert_error @database, :description, :blank
  end

  test 'unique attributes' do
    database = @database.dup

    assert database.invalid?
    assert_error database, :name, :taken
  end

  test 'attributes length' do
    @database.name = 'abcde' * 52
    @database.driver = 'abcde' * 52
    @database.description = 'abcde' * 52

    assert @database.invalid?
    assert_error @database, :name, :too_long, count: 255
    assert_error @database, :driver, :too_long, count: 255
    assert_error @database, :description, :too_long, count: 255
  end

  test 'odbc string' do
    assert_kind_of String, @database.odbc_string
  end

  test 'odbc ini' do
    odbc_ini_path = "#{Etc.getpwuid.dir}/.odbc.ini"
    old_odbc_content = nil

    if File.exist? odbc_ini_path
      File.open(odbc_ini_path, 'r') { |file| old_odbc_content = file.read }
    end

    @database.update! name: "PostgreSQL #{rand}"

    File.open(odbc_ini_path, 'r') do |file|
      assert_not_equal old_odbc_content, file.read
    end
  end

  test 'user' do
    user_property = send 'public.properties', :postgresql_user

    assert_equal user_property.value, @database.user
  end

  test 'password' do
    password_property = send 'public.properties', :postgresql_password

    assert_equal password_property.password, @database.password
  end

  test 'property' do
    property = send 'public.properties', :trace

    assert_equal property.value, @database.property(property.key)
  end

  test 'search' do
    databases = Database.search query: @database.name

    assert databases.present?
    assert databases.all? { |s| s.name =~ /#{@database.name}/ }
  end

  test 'current' do
    skip
  end

  test 'by name' do
    skip
  end

  test 'by driver' do
    skip
  end
end
