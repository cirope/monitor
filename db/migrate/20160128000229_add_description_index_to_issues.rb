# frozen_string_literal: true

class AddDescriptionIndexToIssues < ActiveRecord::Migration[4.2]
  def change
    add_index :issues, :description
  end
end
