class AddSurveyScripts < ActiveRecord::Migration[6.0]
  def change
    create_table :surveys do |t|
      t.timestamps
    end

    create_table :questions do |t|
      t.string :title
      t.belongs_to :survey
      t.string :type
      t.timestamps
    end

    create_table :drop_down_options do |t|
      t.string :value
      t.belongs_to :question
      t.timestamps
    end

    create_table :survey_answers do |t|
      t.belongs_to :survey
      t.timestamps
    end

    create_table :answers do |t|
      t.string :response_text
      t.belongs_to :drop_down_option
      t.belongs_to :survey_answer
      t.belongs_to :question
      t.string :type
      t.timestamps
    end
  end
end
