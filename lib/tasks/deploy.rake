namespace :deploy do
  desc 'Runs upgrade tasks before publishing'
  task :before_publishing do
    %w(tenant:default db:update storage:migrate).each do |task|
      Rake::Task[task].invoke
    end
  end

  desc 'Runs upgrade tasks after finishing'
  task :after_finishing do
    %w(files:move).each do |task|
      Rake::Task[task].invoke
    end
  end
end
