namespace :counters do
  desc 'Reset all counter cache columns'
  task reset: :environment do
		Script.find_each do |script|
      script.update! active_issues_count: script.issues.where.not(status: 'closed').count
		end
  end
end
