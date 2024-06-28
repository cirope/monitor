class JobDestroyJob < ApplicationJob
  queue_as :default

  def perform job
    job.original_destroy if job.cleanup
  end
end
