class AddSessionsTable < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :session_id, null: false, index: { unique: true }
      t.text :data

      t.timestamps null: false
    end

    add_index :sessions, :updated_at
  end
end
