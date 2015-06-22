json.array!(@schedules) do |schedule|
  json.extract! schedule, :id, :start, :end, :interval, :frequency, :script_id, :server_id
  json.url schedule_url(schedule, format: :json)
end
