class AddOptionsToTags < ActiveRecord::Migration
  def change
    add_column :tags, :options, :jsonb
  end
end
