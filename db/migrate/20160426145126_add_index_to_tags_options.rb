class AddIndexToTagsOptions < ActiveRecord::Migration[4.2]
  def change
    add_index :tags, :options, using: :gin
  end
end
