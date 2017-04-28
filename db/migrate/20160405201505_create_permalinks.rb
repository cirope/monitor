class CreatePermalinks < ActiveRecord::Migration[4.2]
  def change
    create_table :permalinks do |t|
      t.string :token, null: false, index: { unique: true }

      t.timestamps null: false
    end
  end
end
