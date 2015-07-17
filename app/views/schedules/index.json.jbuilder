json.array!(@schedules) do |schedule|
  json.extract! schedule, :id, :name
  json.url schedule_url(schedule, format: :json)
end
