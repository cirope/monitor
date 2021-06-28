class CreateFailures < ActiveRecord::Migration[6.0]
  def change
    create_table :failures do |t|
      t.jsonb :data
      t.datetime :created_at, null: false, index: true
      t.references :user, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
    end
  end
end
