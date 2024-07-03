require 'test_helper'

class JobDestroyJobTest < ActiveJob::TestCase
  test 'destroy' do
    schedule = schedules :ls_on_atahualpa
    job      = jobs      :ls_on_atahualpa

    assert_equal schedule.jobs.count, 1

    perform_enqueued_jobs do
      job.destroy
    end

    assert_equal schedule.jobs.count, 0
  end
end
