class AddLastOperatorToCustomizeCourseId < ActiveRecord::Migration
  def change
    add_column :customized_tutorials,:last_operator_id,:integer

  end
end
