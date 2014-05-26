class CreateCoursePurchaseRecords < ActiveRecord::Migration
  def change
    create_table :course_purchase_records do |t|
      t.integer :student_id
      t.integer :course_id
      t.timestamps
    end
    add_column :users,:course_purchase_records_count,:integer
    add_column :courses,:course_purchase_records_count,:integer
  end
end
