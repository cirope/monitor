# TODO: remove :file when migration to ActiveStorage is completed
json.extract! @script, :id, :name, :file, :text, :created_at, :updated_at
