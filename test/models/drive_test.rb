# frozen_string_literal: true

require 'test_helper'

class DriveTest < ActiveSupport::TestCase
  setup do
    @drive = drives :drive_config
  end

  test 'blank attributes' do
    @drive.name       = ''
    @drive.identifier = ''
    @drive.client_id  = ''
    @drive.client_secret = ''

    assert @drive.invalid?
    assert_error @drive, :name, :blank
    assert_error @drive, :identifier, :blank
    assert_error @drive, :client_id, :blank
    assert_error @drive, :client_secret, :blank
  end

  test 'attributes length' do
    @drive.name = 'abcde' * 52
    @drive.identifier = 'abcde' * 52
    @drive.client_id = 'abcde' * 52
    @drive.client_secret = 'abcde' * 52

    assert @drive.invalid?
    assert_error @drive, :name, :too_long, count: 255
    assert_error @drive, :identifier, :too_long, count: 255
    assert_error @drive, :client_id, :too_long, count: 255
    assert_error @drive, :client_secret, :too_long, count: 255
  end

  test 'unique attributes' do
    drive = @drive.dup

    assert drive.invalid?
    assert_error drive, :name, :taken
    assert_error drive, :identifier, :taken
  end

  test 'included attributes' do
    @drive.provider = 'wrong'

    assert @drive.invalid?
    assert_error @drive, :provider, :inclusion
  end
end
