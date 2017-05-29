class CreateJoinTableIssuePermalink < ActiveRecord::Migration[4.2]
  def change
    create_join_table :issues, :permalinks do |t|
      t.references :issue, index: true, null: false, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :permalink, index: true, null: false, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
    end
  end
end
