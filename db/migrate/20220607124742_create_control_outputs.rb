class CreateControlOutputs < ActiveRecord::Migration[6.1]
  def change
    create_table :control_outputs do |t|
      t.string :status, null: false, index: true
      t.text :output
      t.references :control, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
