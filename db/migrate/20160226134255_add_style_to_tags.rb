class AddStyleToTags < ActiveRecord::Migration
  def change
    add_column :tags, :style, :string, null: false, default: 'default'
  end
end
