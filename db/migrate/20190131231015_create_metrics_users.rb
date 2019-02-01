class CreateMetricsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :metrics_users, id: false do |t|
      t.date :date, index: true, default: 'CURRENT_DATE'
      t.string :user_id, index: true
      t.integer :count, default: 0
      t.decimal :amount, precision: 15, scale: 2, default: 0.0
    end
  end
end
