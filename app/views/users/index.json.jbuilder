json.array!(@users) do |user|
  json.extract! user, :id, :email
  json.label user.to_s
end
