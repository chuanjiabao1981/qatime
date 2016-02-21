class RemoveTemplateFromExerciesAndCustomizedTutorial < ActiveRecord::Migration
  def change
    remove_column :examinations,:template_id,:integer
    remove_column :customized_tutorials,:template_id,:integer
  end
end
