class AddUuidToScripts < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    add_column :scripts, :uuid, :uuid, null: false, default: 'uuid_generate_v4()'

    add_index :scripts, :uuid, unique: true
  end
end
