class AddFileToComments < ActiveRecord::Migration
  def change
    add_column :comments, :file, :string
  end
end
