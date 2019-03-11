# frozen_string_literal: true

class AddHiddenToSchedules < ActiveRecord::Migration[4.2]
  def change
    add_column :schedules, :hidden, :boolean, null: false, default: false

    add_index :schedules, :hidden
  end
end
