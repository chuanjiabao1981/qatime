class TopicAble < ActiveRecord::Migration
  def change
    rename_column :topics,:lesson_id,:topicable_id
    add_column    :topics,:topicable_type,:string
    execute <<-SQL
      update topics set topicable_type = 'Lesson'
    SQL
    rename_column :topics,:learning_plan_id,:delete_learning_plan_id
  end

  def down
    rename_column :topics,:topicable_id,:lesson_id
    remove_column :topics,:topicable_type
    rename_column :topics,:delete_learning_plan_id,:learning_plan_id

  end
end
