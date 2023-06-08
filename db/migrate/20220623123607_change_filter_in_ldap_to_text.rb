class ChangeFilterInLdapToText < ActiveRecord::Migration[6.1]
  def change
    change_column :ldaps, :filter, :text
  end
end
