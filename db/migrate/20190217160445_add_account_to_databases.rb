class AddAccountToDatabases < ActiveRecord::Migration[5.2]
  def change
    change_table :databases do |t|
      # TODO: add null false later
      t.references :account, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
    end
  end
end
