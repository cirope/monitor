# frozen_string_literal: true

require 'test_helper'

class DependencyTest < ActiveSupport::TestCase
  setup do
    @dependency = dependencies :last_cd_runs_on_atahualpa
  end

  test 'blank attributes' do
    @dependency.schedule = nil

    assert @dependency.invalid?
    assert_error @dependency, :schedule, :blank
  end
end
