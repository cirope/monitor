class AddChangeToScripts < ActiveRecord::Migration
  def change
    add_column :scripts, :change, :string
  end
end
