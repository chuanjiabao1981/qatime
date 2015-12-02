class AddSomeColumnsToExamination < ActiveRecord::Migration
  def change
    add_column :examinations,:last_operator_id,:integer
    add_column :examinations,:first_handled_at,:timestamp
    add_column :examinations,:completed_at,:timestamp
    add_column :examinations,:last_handled_at,:timestamp
    add_column :examinations,:last_redone_at,:timestamp

  end
end
