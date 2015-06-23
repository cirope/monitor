json.array!(@runs) do |run|
  json.extract! run, :id, :schedule_id, :status, :scheduled_start, :started_at, :ended_at, :output
  json.url run_url(run, format: :json)
end
