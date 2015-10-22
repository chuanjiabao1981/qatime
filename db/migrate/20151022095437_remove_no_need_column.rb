class RemoveNoNeedColumn < ActiveRecord::Migration
  def change
    remove_column :examinations,:homework_corrections_count,:integer,default:0
    remove_column :examinations,:exercise_corrections_count,:integer,default:0
    remove_column :examinations,:exercise_solutions_count,:integer,default:0
    remove_column :examinations,:homework_solutions_count,:integer,default: 0

  end
end
