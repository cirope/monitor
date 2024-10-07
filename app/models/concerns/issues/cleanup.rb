module Issues::Cleanup
  extend ActiveSupport::Concern

  module ClassMethods
    def cleanup_job issue_ids
      IssueCleanupJob.perform_later issue_ids
    end

    def cleanup issue_ids
      Issue.where(id: issue_ids).find_each &:destroy
    end
  end
end
