class AddIndexOnCommentsText < ActiveRecord::Migration[5.0]
  def change
    add_index :comments, :text
  end
end
