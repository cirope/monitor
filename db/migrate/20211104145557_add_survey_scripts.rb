class AddSurveyScripts < ActiveRecord::Migration[6.0]
  def change
    create_table :surveys do |t|
      t.references :issue, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.timestamps null: false
    end

    create_table :questions do |t|
      t.string :title, null: false
      t.references :survey, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.string :type, null: false
      t.timestamps null: false
    end

    create_table :drop_down_options do |t|
      t.string :value
      t.integer :score
      t.references :question, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.timestamps null: false
    end

    create_table :survey_answers do |t|
      t.references :survey, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :user, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.timestamps null: false
    end

    create_table :answers do |t|
      t.string :response_text
      t.references :drop_down_option, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :survey_answer, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :question, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.string :type, null: false
      t.timestamps null: false
    end
  end
end
