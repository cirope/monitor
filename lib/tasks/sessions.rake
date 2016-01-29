namespace :sessions do
  desc 'Remove old sessions'
  task clear: :environment do
    ActiveRecord::SessionStore::Session.where('updated_at < ?', 1.week.ago).delete_all
  end
end
