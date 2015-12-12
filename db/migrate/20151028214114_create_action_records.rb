class CreateActionRecords < ActiveRecord::Migration
  def change
    create_table :action_records do |t|
      t.integer :operator_id
      t.integer :customized_course_id
      t.string  :actionable_type
      t.integer :actionable_id
      t.string  :name
      t.string  :type
      t.timestamps null: false
    end
  end
end
