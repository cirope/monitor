# frozen_string_literal: true

require 'test_helper'

class Reminders::States::ScheduledTest < ActiveSupport::TestCase
  test 'notify do nothing' do
    reminder = reminders :reminder_of_ls_on_atahualpa_not_well
    state    = Reminders::States::Scheduled.new

    state.notify reminder

    assert_equal 'done', reminder.reload.state_class_type
    assert_equal reminder.issue.users.count, ActionMailer::Base.deliveries.count

    ActionMailer::Base.deliveries.clear
  end
end
