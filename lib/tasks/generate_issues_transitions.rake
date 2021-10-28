# frozen_string_literal: true

namespace :generate_issues_transitions do
  desc 'Generate state transitions of all issues'
  task generate: :environment do
    generate_transitions
  end
end

private

  def generate_transitions
    ActiveRecord::Base.transaction do
      Account.all.each do |account|
        account.switch!

        Issue.all.each do |issue|
          transitions_hash = {}

          issue.versions.each do |version|
            if version.object_changes.key? 'status'
              date_time_transition = DateTime.parse(version.object_changes['updated_at'][1]).to_s :db

              transitions_hash[date_time_transition] = version.object_changes['status'][1]
            end
          end

          issue.update! transitions: transitions_hash

          puts "transitions of issue id: #{issue.id} with #{transitions_hash} saved!"
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    puts e
  end
