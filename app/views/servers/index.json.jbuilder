json.array!(@servers) do |server|
  json.extract! server, :id, :name
end
