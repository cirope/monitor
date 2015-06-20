class CreateLdaps < ActiveRecord::Migration
  def change
    create_table :ldaps do |t|
      t.string :hostname, null: false
      t.integer :port, default: 389, null: false
      t.string :basedn, null: false
      t.string :filter
      t.string :login_mask, null: false
      t.string :username_attribute, null: false
      t.string :name_attribute, null: false
      t.string :lastname_attribute, null: false
      t.string :email_attribute, null: false
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end
