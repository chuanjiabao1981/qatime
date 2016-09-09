class AddColumnsToActionRecords < ActiveRecord::Migration
  def change
    add_column :action_records, :live_studio_course_id, :integer
    add_column :action_records, :live_studio_lesson_id, :integer
    add_column :action_records, :content, :text
    add_column :action_records, :category, :string
  end
end
