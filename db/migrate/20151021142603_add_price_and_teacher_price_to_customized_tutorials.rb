class AddPriceAndTeacherPriceToCustomizedTutorials < ActiveRecord::Migration
  def change
    add_column :customized_tutorials,:teacher_price,:integer
    add_column :customized_tutorials,:price,:integer
  end
end