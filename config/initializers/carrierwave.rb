CarrierWave.configure do |config|
  config.root = Rails.root
  config.storage = :file
  config.enable_processing = !Rails.env.test?
end
