class AddParentIdToScripts < ActiveRecord::Migration
  def change
    add_reference :scripts, :parent, index: true

    add_foreign_key :scripts, :scripts, column: :parent_id, on_delete: :restrict, on_update: :restrict
  end
end
