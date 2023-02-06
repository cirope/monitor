class DropDasbboardsAndDeps < ActiveRecord::Migration[7.0]
  def change
    drop_table :queries
    drop_table :panels
    drop_table :dashboards
  end
end
