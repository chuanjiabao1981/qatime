class CreateCoursePurchaseRecords < ActiveRecord::Migration
  def change
    create_table :course_purchase_records do |t|
      t.references :student
      t.references :course
      t.timestamps
    end
    add_column :users,:course_purchase_records_count,:integer
    add_column :courses,:course_purchase_records_count,:integer
  end
end
