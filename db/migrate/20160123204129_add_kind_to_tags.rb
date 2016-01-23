class AddKindToTags < ActiveRecord::Migration
  def change
    add_column :tags, :kind, :string, null: false, default: 'script'

    add_index :tags, :kind
  end
end
