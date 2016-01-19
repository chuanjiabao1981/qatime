class AddExerciseTemplateToExamination < ActiveRecord::Migration
  def change
    add_column :examinations,:template_id,:integer
  end
end
