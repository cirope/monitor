# frozen_string_literal: true

class AddRolesAttributeToLdap < ActiveRecord::Migration[4.2]
  def change
    add_column :ldaps, :roles_attribute, :string, null: false
  end
end
