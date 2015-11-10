class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :status, null: false, index: true
      t.jsonb :data, index: { using: :gin }
      t.references :run, index: true, null: false, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps null: false
    end

    add_index :issues, :created_at
  end
end
