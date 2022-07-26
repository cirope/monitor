Rails.application.reloader.to_prepare do
  MountDrivesJob.set(wait: 5.seconds).perform_later
end
