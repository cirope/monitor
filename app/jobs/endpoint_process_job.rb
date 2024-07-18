class EndpointProcessJob < ApplicationJob
  queue_as :default

  def perform endpoint
    endpoint.process
  end
end
