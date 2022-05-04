# frozen_string_literal: true

require 'test_helper'

class Reminders::States::PendingTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test 'notify do nothing' do
    reminder = reminders :reminder_of_ls_on_atahualpa_not_well
    state    = Reminders::States::Pending.new

    state.notify reminder

    refute reminder.state_class_type_change
    assert_no_enqueued_emails
  end
end
