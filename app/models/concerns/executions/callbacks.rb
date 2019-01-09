module Executions::Callbacks
  extend ActiveSupport::Concern

  included do
    after_commit :schedule_execution, on: :create
  end

  private

    def schedule_execution
      ExecutionJob.perform_later self.id
    end
end
