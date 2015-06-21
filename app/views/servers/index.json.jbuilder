json.array!(@servers) do |server|
  json.extract! server, :id, :name, :hostname, :user, :password, :credential
  json.url server_url(server, format: :json)
end
