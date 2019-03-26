# frozen_string_literal: true

class AddOptionsToTags < ActiveRecord::Migration[4.2]
  def change
    add_column :tags, :options, :jsonb
  end
end
