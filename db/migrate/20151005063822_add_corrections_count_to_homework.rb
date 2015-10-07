class AddCorrectionsCountToHomework < ActiveRecord::Migration
  def change
    add_column :homeworks,:corrections_count,:integer,default: 0
    add_column :corrections,:homework_id,:integer
  end
end
