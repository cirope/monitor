# frozen_string_literal: true

class AddDataToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :data, :jsonb
    add_index  :runs, :data, using: :gin
  end
end
