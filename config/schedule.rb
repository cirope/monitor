env :PATH, ENV['PATH']

every 1.minutes do
  runner 'Schedule.schedule; Run.schedule'
end

every 1.minutes do
  check   = '(ps aux | grep sidekiq | grep -v grep) > /dev/null'
  restart = "(cd #{path} && bundle exec cap localhost sidekiq:restart)"

  command "#{check} || #{restart}"
end

every 1.day do
  rake 'sessions:clear'
end
