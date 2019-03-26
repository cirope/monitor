# frozen_string_literal: true

class AddFileToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :file, :string
  end
end
