class IssueCleanupJob < ApplicationJob
  queue_as :default

  def perform issues_ids
    Issue.cleanup issues_ids
  end
end
