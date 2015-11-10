class AddDataToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :data, :jsonb
    add_index  :runs, :data, using: :gin
  end
end
