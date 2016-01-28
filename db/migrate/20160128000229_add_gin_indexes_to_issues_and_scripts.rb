class AddGinIndexesToIssuesAndScripts < ActiveRecord::Migration
  def change
    enable_extension 'btree_gin'

    remove_index :scripts, :name

    add_index :issues, :description, using: :gin
    add_index :scripts, :name, using: :gin
  end
end
