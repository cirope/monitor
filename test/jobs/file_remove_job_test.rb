# frozen_string_literal: true

require 'test_helper'

class FileRemoveJobTest < ActiveJob::TestCase
  test 'remove' do
    path = Rails.root.join 'test', "#{SecureRandom.uuid}.txt"

    FileUtils.touch path

    assert path.exist?

    FileRemoveJob.perform_now path

    sleep ENV['GH_ACTIONS'] ? 0.12 : 0.02

    assert !path.exist?
  end
end
