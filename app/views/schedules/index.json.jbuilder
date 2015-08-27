json.array!(@schedules) do |schedule|
  json.extract! schedule, :id, :name
end
