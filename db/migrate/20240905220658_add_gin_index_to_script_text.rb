class AddGinIndexToScriptText < ActiveRecord::Migration[7.0]
  def change
    add_index :scripts, :text, using: :gin, opclass: :gin_trgm_ops
  end
end
