class CreateEndpoints < ActiveRecord::Migration[7.0]
  def change
    create_table :endpoints do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :provider, null: false, default: 'dynamics'
      t.jsonb :options
      t.jsonb :session
      t.integer :lock_version, default: 0, null: false

      t.timestamps
    end
  end
end
