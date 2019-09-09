# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.text :text, null: false
      t.references :user, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :issue, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps null: false
    end
  end
end
