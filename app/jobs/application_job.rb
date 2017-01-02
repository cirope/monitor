class ApplicationJob < ActiveJob::Base
  rescue_from ActiveJob::DeserializationError do |exception|
    Rails.logger.warn "DeserializationError: #{exception}"
  end
end
