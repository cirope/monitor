class AddKindToTags < ActiveRecord::Migration[4.2]
  def change
    add_column :tags, :kind, :string, null: false, default: 'script'

    add_index :tags, :kind
  end
end
