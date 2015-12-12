class AddHomeworkCorrectionCountToExamination < ActiveRecord::Migration
  def change
    add_column :examinations,:homework_corrections_count,:integer,default:0
    add_column :examinations,:exercise_corrections_count,:integer,default:0
    add_column :examinations,:exercise_solutions_count,:integer,default:0
  end
end
