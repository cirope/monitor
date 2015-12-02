class AddOptionsToLdap < ActiveRecord::Migration
  def change
    add_column :ldaps, :options, :jsonb
  end
end
