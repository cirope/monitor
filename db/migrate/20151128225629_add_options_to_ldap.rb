class AddOptionsToLdap < ActiveRecord::Migration[4.2]
  def change
    add_column :ldaps, :options, :jsonb
  end
end
