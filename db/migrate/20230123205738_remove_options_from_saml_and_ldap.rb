class RemoveOptionsFromSamlAndLdap < ActiveRecord::Migration[7.0]
  def change
    remove_column :ldaps, :options
    remove_column :samls, :options
  end
end
