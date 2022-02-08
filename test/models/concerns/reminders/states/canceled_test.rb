# frozen_string_literal: true

require 'test_helper'

class Reminders::States::CanceledTest < ActiveSupport::TestCase
  test 'notify do nothing' do
    reminder = reminders :reminder_of_ls_on_atahualpa_not_well
    state    = Reminders::States::Canceled.new

    state.notify reminder

    refute reminder.state_class_type_change
    assert ActionMailer::Base.deliveries.count.zero?
  end
end
