class CreatePermalinks < ActiveRecord::Migration
  def change
    create_table :permalinks do |t|
      t.string :token, null: false, index: { unique: true }

      t.timestamps null: false
    end
  end
end
