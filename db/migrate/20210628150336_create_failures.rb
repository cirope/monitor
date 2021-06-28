class CreateFailures < ActiveRecord::Migration[6.0]
  def change
    create_table :failures do |t|
      t.jsonb :data
      t.datetime :created_at, null: false
      t.references :user, null: true
    end
  end
end
