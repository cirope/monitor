# frozen_string_literal: true

require 'test_helper'

class ReminderJobTest < ActiveJob::TestCase
  test 'send email when reminder schedule' do
    reminder                  = reminders :reminder_of_ls_on_atahualpa_not_well
    reminder.state_class_type = 'scheduled'

    ReminderJob.perform_now reminder

    assert_equal 'done', reminder.reload.state_class_type
  end
end
