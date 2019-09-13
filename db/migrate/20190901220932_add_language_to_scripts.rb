# frozen_string_literal: true

class AddLanguageToScripts < ActiveRecord::Migration[5.2]
  def change
    add_column :scripts, :language, :string, default: 'ruby'
  end
end
