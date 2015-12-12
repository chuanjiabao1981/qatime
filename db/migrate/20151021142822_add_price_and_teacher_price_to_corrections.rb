class AddPriceAndTeacherPriceToCorrections < ActiveRecord::Migration
  def change
    add_column :corrections,:teacher_price,:integer
    add_column :corrections,:price,:integer
  end
end
