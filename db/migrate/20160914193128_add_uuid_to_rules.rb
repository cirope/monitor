class AddUuidToRules < ActiveRecord::Migration[5.0]
  def change
    add_column :rules, :uuid, :uuid, null: false, default: 'md5(random()::text || clock_timestamp()::text)::uuid'

    add_index :rules, :uuid, unique: true
  end
end
