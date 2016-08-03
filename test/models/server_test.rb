require 'test_helper'

class ServerTest < ActiveSupport::TestCase
  setup do
    @server = servers :atahualpa
  end

  test 'blank attributes' do
    @server.name = ''
    @server.hostname = ''

    assert @server.invalid?
    assert_error @server, :name, :blank
    assert_error @server, :hostname, :blank
  end

  test 'unique attributes' do
    server = @server.dup

    assert server.invalid?
    assert_error server, :name, :taken
  end

  test 'attribute length' do
    @server.name = 'abcde' * 52
    @server.hostname = 'abcde' * 52
    @server.user = 'abcde' * 52
    @server.password = 'abcde' * 52

    assert @server.invalid?
    assert_error @server, :name, :too_long, count: 255
    assert_error @server, :hostname, :too_long, count: 255
    assert_error @server, :user, :too_long, count: 255
    assert_error @server, :password, :too_long, count: 255
  end

  test 'user or credential' do
    @server.user = ''

    assert @server.invalid?
    assert_error @server, :user, :blank
  end

  test 'local' do
    assert @server.local?

    @server.hostname = 'cirope.com'

    assert !@server.local?
  end

  test 'search' do
    servers = Server.search query: @server.name

    assert servers.present?
    assert servers.all? { |s| s.name =~ /#{@server.name}/ }
  end

  test 'execute' do
    skip
  end

  test 'ssh options' do
    skip
  end

  test 'by name' do
    skip
  end

  test 'by hostname' do
    skip
  end

  test 'by user' do
    skip
  end
end
