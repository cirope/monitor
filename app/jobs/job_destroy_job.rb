class JobDestroyJob < ApplicationJob
  queue_as :default

  def perform job
    job.delete if job.cleanup
  end
end
