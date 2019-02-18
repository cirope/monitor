class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.references :account, index: true, null: false, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.string :email, index: true, null: false
      t.string :username, index: true
      t.boolean :default, null: false, default: false

      t.timestamps null: false
    end

    add_index :memberships, [:account_id, :email], unique: true
  end
end
