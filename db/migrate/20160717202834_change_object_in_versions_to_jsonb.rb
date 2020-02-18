# frozen_string_literal: true

class ChangeObjectInVersionsToJsonb < ActiveRecord::Migration[5.0]
  def up
    change_column :versions, :object, :jsonb, using: 'object::jsonb'
    change_column :versions, :object_changes, :jsonb, using: 'object_changes::jsonb'
  end

  def down
    change_column :versions, :object, :json, using: 'object::json'
    change_column :versions, :object_changes, :json, using: 'object_changes::json'
  end
end
