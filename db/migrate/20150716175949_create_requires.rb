# frozen_string_literal: true

class CreateRequires < ActiveRecord::Migration[4.2]
  def change
    create_table :requires do |t|
      t.references :caller, index: true, null: false
      t.references :script, index: true, null: false, foreign_key: {
        on_update: :restrict,
        on_delete: :restrict
      }

      t.timestamps null: false
    end

    add_foreign_key :requires, :scripts, column: :caller_id, on_update: :restrict, on_delete: :restrict
  end
end
