# TODO: remove :credential when migration to ActiveStorage gets completed
json.extract! @server, :id, :name, :hostname, :user, :password, :credential, :created_at, :updated_at
