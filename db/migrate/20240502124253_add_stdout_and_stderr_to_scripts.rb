class AddStdoutAndStderrToScripts < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :debug_mode

    rename_column :runs, :output, :stdout
    rename_column :executions, :output, :stdout

    add_column :runs, :stderr, :text
    add_column :executions, :stderr, :text

    add_column :scripts, :status, :jsonb
    add_index :scripts, :status, using: :gin
  end
end
