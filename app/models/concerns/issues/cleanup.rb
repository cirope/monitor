module Issues::Cleanup
  extend ActiveSupport::Concern

  module ClassMethods
    def cleanup_job issues_ids
      IssueCleanupJob.perform_later issues_ids
    end

    def cleanup issues_ids
      Issue.where(id: issues_ids).find_each &:destroy
    end
  end
end
