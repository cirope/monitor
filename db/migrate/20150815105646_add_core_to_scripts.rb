# frozen_string_literal: true

class AddCoreToScripts < ActiveRecord::Migration[4.2]
  def change
    add_column :scripts, :core, :boolean
    add_index  :scripts, :core
  end
end
