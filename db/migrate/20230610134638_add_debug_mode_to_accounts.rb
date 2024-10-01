class AddDebugModeToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :debug_mode, :boolean, null: false, default: true
  end
end
