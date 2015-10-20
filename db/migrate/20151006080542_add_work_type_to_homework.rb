class AddWorkTypeToHomework < ActiveRecord::Migration
  def change
    add_column :examinations,:work_type,:string
  end
end
