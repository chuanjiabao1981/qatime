class AddWorkTypeToHomework < ActiveRecord::Migration
  def change
    add_column :homeworks,:work_type,:string
  end
end
