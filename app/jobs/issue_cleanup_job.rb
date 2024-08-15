class IssueCleanupJob < ApplicationJob
  queue_as :default

  def perform issue_ids
    Issue.cleanup issue_ids
  end
end
