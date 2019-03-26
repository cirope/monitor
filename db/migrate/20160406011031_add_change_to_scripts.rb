# frozen_string_literal: true

class AddChangeToScripts < ActiveRecord::Migration[4.2]
  def change
    add_column :scripts, :change, :string
  end
end
