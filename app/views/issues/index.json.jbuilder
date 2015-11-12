json.array!(@issues) do |issue|
  json.extract! issue, :id, :data, :run_id
  json.url issue_url(issue, format: :json)
end
