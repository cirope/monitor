class CreateDrives < ActiveRecord::Migration[6.1]
  def change
    create_table :drives do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :provider, null: false
      t.string :client_id, null: false
      t.string :client_secret, null: false
      t.string :identifier, null: false, index: true
      t.string :code
      t.references :account, index: true, null: false, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end
