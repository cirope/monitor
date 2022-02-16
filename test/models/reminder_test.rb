# frozen_string_literal: true

require 'test_helper'

class ReminderTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  include ActionMailer::TestHelper

  setup do
    @reminder = reminders :reminder_of_ls_on_atahualpa_not_well
  end

  test 'invalid without due_at' do
    @reminder.due_at = nil

    assert @reminder.invalid?
    assert_error @reminder, :due_at, :blank
  end

  test 'invalid with type time in due_at' do
    @reminder.due_at = '23:11:10'

    assert @reminder.invalid?
    assert_error @reminder, :due_at, :blank
    assert_error @reminder, :due_at, :invalid_datetime
  end

  test 'invalid with blank or diferent state' do
    @reminder.state_class_type = ''

    assert @reminder.invalid?
    assert_error @reminder, :state_class_type, :blank

    @reminder.state_class_type = 'Done'

    assert @reminder.invalid?
    assert_error @reminder, :state_class_type, :inclusion
  end

  test 'valid without state' do
    @reminder.state_class_type = nil

    assert @reminder.valid?
    assert_equal 'pending', @reminder.state_class_type
  end

  test 'change state when new issue status' do
    @reminder.transition_rules = { 'status_changed': { 'taken': 'done' } }

    @reminder.new_issue_status 'taken'

    assert @reminder.state_class_type_change
    assert_equal 'done', @reminder.state_class_type
  end

  test 'dont change state when new issue status' do
    @reminder.transition_rules = { 'status_changed': { 'taken': 'done' } }

    @reminder.new_issue_status 'pending'

    refute @reminder.state_class_type_change
  end

  test 'reminder scheduled' do
    @reminder.scheduled

    assert_equal 'scheduled', @reminder.reload.state_class_type
  end

  test 'return pending state' do
    assert_instance_of Reminders::States::Pending, @reminder.state
  end

  test 'return scheduled state' do
    @reminder.state_class_type = 'scheduled'

    assert_instance_of Reminders::States::Scheduled, @reminder.state
  end

  test 'return canceled state' do
    @reminder.state_class_type = 'canceled'

    assert_instance_of Reminders::States::Canceled, @reminder.state
  end

  test 'return done state' do
    @reminder.state_class_type = 'done'

    assert_instance_of Reminders::States::Done, @reminder.state
  end

  test 'return pending reminders' do
    reminders = Reminder.pending

    assert_equal @reminder.id, reminders.first.id

    @reminder.state_class_type = 'scheduled'
    @reminder.save!

    reminders = Reminder.pending

    assert reminders.blank?
  end

  test 'return next_to_schedule reminders' do
    reminders = Reminder.next_to_schedule

    assert_equal @reminder.id, reminders.first.id

    @reminder.due_at = 11.minutes.from_now
    @reminder.save!

    reminders = Reminder.next_to_schedule

    assert reminders.blank?
  end

  test 'do nothing when pending state' do
    @reminder.notify

    assert_equal 'pending', @reminder.state_class_type
    assert_no_enqueued_emails
  end

  test 'send email and change to done when scheduled state' do
    @reminder.state_class_type = 'scheduled'

    @reminder.notify

    assert_equal 'done', @reminder.reload.state_class_type
    assert_enqueued_emails 2
  end

  test 'do nothing when done state' do
    @reminder.state_class_type = 'done'

    @reminder.notify

    assert_equal 'done', @reminder.state_class_type
    assert_no_enqueued_emails
  end

  test 'do nothing when canceled state' do
    @reminder.state_class_type = 'canceled'

    @reminder.notify

    assert_equal 'canceled', @reminder.state_class_type
    assert_no_enqueued_emails
  end

  test 'schedule reminders' do
    assert_enqueued_with(job: ReminderJob) do
      Reminder.schedule
    end
  end
end
