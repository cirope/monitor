namespace :endpoints do
  desc 'Process endpoints api'
  task process: :environment do
    ::Endpoint.process
  end
end
