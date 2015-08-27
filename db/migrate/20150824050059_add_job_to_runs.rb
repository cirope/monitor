class AddJobToRuns < ActiveRecord::Migration
  def change
    change_table :runs do |t|
      t.remove :schedule_id
      t.references :job, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
    end
  end
end
