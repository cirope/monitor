# frozen_string_literal: true

require 'test_helper'

class Reminders::States::ScheduledTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test 'notify do nothing' do
    reminder = reminders :reminder_of_ls_on_atahualpa_not_well
    state    = Reminders::States::Scheduled.new

    state.notify reminder

    assert_equal 'done', reminder.reload.state_class_type
    assert_enqueued_emails 2
  end
end
