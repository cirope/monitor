# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :subscriptions do |t|
      t.references :issue, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :user, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps null: false
    end
  end
end
