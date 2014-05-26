class AddUniqueToCoursePurchase < ActiveRecord::Migration
  def up
    execute <<-SQL
  		ALTER TABLE course_purchase_records ADD CONSTRAINT student_id_course_id UNIQUE (student_id,course_id)
    SQL
    add_index :course_purchase_records,:student_id
    add_index :course_purchase_records,:course_id
  end
  def down
    execute <<-SQL
  		ALTER TABLE course_purchase_records DROP CONSTRAINT student_id_course_id;
    SQL
    remove_index :course_purchase_records,:student_id
    remove_index :course_purchase_records,:course_id
  end
end
