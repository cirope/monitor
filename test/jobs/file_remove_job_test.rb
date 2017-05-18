require 'test_helper'

class FileRemoveJobTest < ActiveJob::TestCase
  test 'remove' do
    path = Rails.root.join 'test', "#{SecureRandom.uuid}.txt"

    FileUtils.touch path

    assert path.exist?

    FileRemoveJob.perform_now path

    sleep 0.002

    assert !path.exist?
  end
end
