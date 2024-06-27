# frozen_string_literal: true

require 'test_helper'

class Schedules::JobsControllerTest < ActionController::TestCase
  setup do
    @job = jobs :ls_on_atahualpa

    login
  end

  test 'should run job' do
    @schedule = @job.schedule

    assert_difference '@schedule.runs.count'  do
      get :show, params: { schedule_id: @schedule, id: @job }
    end

    assert_redirected_to schedule_runs_url(@schedule)
  end
end
