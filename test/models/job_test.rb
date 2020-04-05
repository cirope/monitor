# frozen_string_literal: true

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  setup do
    @job = jobs :cd_root_on_atahualpa
  end

  test 'blank attributes' do
    @job.server = nil
    @job.script = nil

    assert @job.invalid?
    assert_error @job, :server, :blank
    assert_error @job, :script, :blank
  end

  test 'destroy' do
    skip
  end

  test 'cleanup' do
    skip
  end
end
