# frozen_string_literal: true

class CreateJoinTableIssuePermalink < ActiveRecord::Migration[4.2]
  def change
    create_join_table(
      :issues,
      :permalinks,
      column_options: {
        index:       true,
        null:        false,
        foreign_key: {
          on_delete: :restrict,
          on_update: :restrict
        }
      }
    )
  end
end
