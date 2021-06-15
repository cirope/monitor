class CreateLogins < ActiveRecord::Migration[6.0]
  def change
    create_table :logins do |t|
      t.jsonb :data
      t.datetime :closed_at
      t.datetime :created_at, null: false, index: true
      t.references :user, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
    end
  end
end
