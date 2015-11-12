json.array! @rules do |rule|
  json.extract! rule, :id, :name, :enabled
end
