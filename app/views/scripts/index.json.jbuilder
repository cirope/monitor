json.array!(@scripts) do |script|
  json.extract! script, :id, :name, :file, :text
  json.url script_url(script, format: :json)
end
