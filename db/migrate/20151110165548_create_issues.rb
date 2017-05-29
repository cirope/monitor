class CreateIssues < ActiveRecord::Migration[4.2]
  def change
    create_table :issues do |t|
      t.string :status, null: false, index: true
      t.text :description
      t.jsonb :data, index: { using: :gin }
      t.references :run, index: true, null: false, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end

    add_index :issues, :created_at
  end
end
