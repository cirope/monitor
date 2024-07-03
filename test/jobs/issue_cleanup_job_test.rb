require 'test_helper'

class IssueCleanupJobTest < ActiveJob::TestCase
  test 'perform' do
    assert_equal Issue.count, 6

    perform_enqueued_jobs do
      Issue.cleanup_job Issue.ids
    end

    assert_equal Issue.count, 0
  end
end
