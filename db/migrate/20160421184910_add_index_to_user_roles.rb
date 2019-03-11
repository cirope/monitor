# frozen_string_literal: true

class AddIndexToUserRoles < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :role
  end
end
