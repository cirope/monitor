# frozen_string_literal: true

env :PATH, ENV['PATH']

every 5.minutes do
  runner 'Schedule.schedule; Run.schedule; Reminder.schedule'
end

every 1.day do
  rake 'sessions:clear'
  runner 'Run.cleanup_job; Execution.cleanup_job'
end
