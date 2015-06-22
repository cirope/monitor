json.array!(@scripts) do |script|
  json.extract! script, :id, :name
end
