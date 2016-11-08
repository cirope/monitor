class AddIndexToTagsOptions < ActiveRecord::Migration
  def change
    add_index :tags, :options, using: :gin
  end
end
