json.array!(@descriptors) do |descriptor|
  json.extract! descriptor, :id, :name
  json.url descriptor_url(descriptor, format: :json)
end
