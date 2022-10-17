class CreatePdfTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :pdf_templates do |t|
      t.string :name, null: false
      t.text :content, size: :long

      t.integer :lock_version, default: 0, null: false
      t.timestamps
    end
  end
end
