# frozen_string_literal: true

class AddStyleToTags < ActiveRecord::Migration[4.2]
  def change
    add_column :tags, :style, :string, null: false, default: 'default'
  end
end
