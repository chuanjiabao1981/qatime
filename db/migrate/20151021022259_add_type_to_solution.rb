class AddTypeToSolution < ActiveRecord::Migration
  def change
    add_column :solutions,:type,:string
    add_column :solutions,:homework_id,:integer
    add_column :examinations,:homework_solutions_count,:integer,default: 0
  end
end
