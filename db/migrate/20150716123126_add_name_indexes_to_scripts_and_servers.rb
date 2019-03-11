# frozen_string_literal: true

class AddNameIndexesToScriptsAndServers < ActiveRecord::Migration[4.2]
  def change
    add_index :scripts, :name
    add_index :servers, :name
  end
end
