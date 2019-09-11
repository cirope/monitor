Rails.application.config.middleware.swap(
  ::Rack::Sendfile,
  ::Rack::Sendfile, 'X-Accel-Redirect', [
    ["#{Rails.root}/private", 'private_files'],
    ["#{Rails.root}/storage", 'storage_files']
  ]
)
