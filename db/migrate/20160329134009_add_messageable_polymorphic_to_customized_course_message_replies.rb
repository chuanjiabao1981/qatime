class AddMessageablePolymorphicToCustomizedCourseMessageReplies < ActiveRecord::Migration
  def up
    change_table :customized_course_message_replies do |t|
      t.references :messageble, polymorphic: true
    end
  end

  def down
    change_table :customized_course_message_replies do |t|
      t.remove_references :messageble, polymorphic: true
    end
  end
end
