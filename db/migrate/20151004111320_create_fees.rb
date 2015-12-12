class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.integer :customized_course_id
      t.integer :feeable_id
      t.string :feeable_type
      t.float :value

      t.timestamps null: false
    end
  end
end
