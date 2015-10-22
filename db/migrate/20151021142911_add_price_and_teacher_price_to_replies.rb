class AddPriceAndTeacherPriceToReplies < ActiveRecord::Migration
  def change
    add_column :replies,:teacher_price,:integer
    add_column :replies,:price,:integer
  end
end
