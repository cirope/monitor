require 'test_helper'

class ExecutionTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    @execution = executions :live_ls
  end

  test 'blank attributes' do
    @execution.server_id = nil

    assert @execution.invalid?
    assert_error @execution, :server, :blank
  end

  test 'schedule live execution after create' do
    execution = @execution.dup

    assert_enqueued_jobs 1 do
      execution.save!
    end
  end
end
