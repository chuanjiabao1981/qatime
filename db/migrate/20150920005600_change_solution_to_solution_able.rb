class ChangeSolutionToSolutionAble < ActiveRecord::Migration
  def change
    rename_column :solutions, :homework_id, :solutionable_id
    add_column    :solutions, :solutionable_type,:string
  end
end
