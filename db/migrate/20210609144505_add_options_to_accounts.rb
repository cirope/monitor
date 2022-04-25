class AddOptionsToAccounts < ActiveRecord::Migration[6.0]
  def change
    change_table :accounts do |t|
      t.jsonb :options
    end
  end
end
