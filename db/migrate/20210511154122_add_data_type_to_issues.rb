class AddDataTypeToIssues < ActiveRecord::Migration[6.0]
  def change
    change_table :issues do |t|
      t.string :data_type
    end
  end
end
