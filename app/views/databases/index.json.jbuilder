json.array!(@databases) do |database|
  json.extract! database, :id, :name, :driver, :description
  json.url database_url(database, format: :json)
end
