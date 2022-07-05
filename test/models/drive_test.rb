# frozen_string_literal: true

require 'test_helper'

class DriveTest < ActiveSupport::TestCase
  setup do
    @drive = drives :one
  end

  test 'blank attributes' do
    @drive.attr = ''

    assert @drive.invalid?
    assert_error @drive, :attr, :blank
  end

  test 'unique attributes' do
    drive = @drive.dup

    assert drive.invalid?
    assert_error drive, :attr, :taken
  end
end
