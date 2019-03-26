# frozen_string_literal: true

class ChangeValueColumnsToTextOnParametersAndDescriptions < ActiveRecord::Migration[5.0]
  def change
    change_column :descriptions, :value, :text
    change_column :parameters, :value, :text
  end
end
