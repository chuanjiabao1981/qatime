class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.integer :customized_course_id
      t.integer :feedable_id
      t.string :feeable_type
      t.float :value
      t.string :status

      t.timestamps null: false
    end
  end
end
