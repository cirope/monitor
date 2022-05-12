# frozen_string_literal: true

class AddOptionsToIssues < ActiveRecord::Migration[6.0]
  def change
    change_table :issues do |t|
      t.jsonb :options
    end
  end
end
