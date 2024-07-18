module Endpoints::Process
  extend ActiveSupport::Concern

  def process
    send "#{provider}_process"
  end

  module ClassMethods
    def process
      Account.on_each do
        Endpoint.find_each do |endpoint|
          EndpointProcessJob.perform_later endpoint
        end
      end
    end
  end
end
