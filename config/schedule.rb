every 1.minutes do
  runner 'Schedule.schedule; Run.schedule'
end

every 30.minutes do
  command "cd #{path} && bundle exec cap localhost sidekiq:restart"
end

every 1.day do
  rake 'sessions:clear'
end
