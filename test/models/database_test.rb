require 'test_helper'

class DatabaseTest < ActiveSupport::TestCase
  def setup
    @database = databases :postgresql
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
end
