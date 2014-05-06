class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string  :name
      t.string  :city_name
      t.string  :school_name
      t.string  :teacher_name
      t.integer :city_id
      t.integer :school_id
      t.integer :teacher_id
      t.timestamps
    end
  end
end
