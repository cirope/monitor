module Executions::Cleanup
  extend ActiveSupport::Concern

  module ClassMethods
    def cleanup_job
      ExecutionCleanupJob.perform_later
    end

    def cleanup
      Account.on_each { cleanup_all }
    end

    private

      def cleanup_all
        cleanup_after = Current.account.cleanup_executions_after.to_i

        if cleanup_after > 0
          days_ago = cleanup_after.days.ago.midnight

          Execution.where(created_at: ..days_ago).find_each do |execution|
            execution.destroy

            execution.versions.map &:destroy
          end
        end
      end
  end
end
