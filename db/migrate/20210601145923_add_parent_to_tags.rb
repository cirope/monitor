# frozen_string_literal: true

class AddParentToTags < ActiveRecord::Migration[6.0]
  def change
    change_table :tags do |t|
      t.references :parent, index: true, null: true, foreign_key: {
        to_table: :tags, on_update: :restrict, on_delete: :restrict
      }
    end
  end
end
