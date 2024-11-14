class AddStyleToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :style, :string, null: false, default: 'default'
  end
end
