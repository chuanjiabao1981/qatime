class TopicAble < ActiveRecord::Migration
  def up
    rename_column :topics,:lesson_id,:topicable_id
    add_column    :topics,:topicable_type,:string
    execute <<-SQL
      update topics set topicable_type = 'Lesson'
    SQL
    rename_column :topics,:learning_plan_id,:delete_learning_plan_id
    rename_column :courses,:topics_count,   :delete_topics_count
    rename_column :curriculums,:topics_count,:delete_topics_count
    add_column    :customized_tutorials, :topics_count,:integer,default: 0
  end

  def down
    rename_column :topics,:topicable_id,:lesson_id
    remove_column :topics,:topicable_type
    rename_column :topics,:delete_learning_plan_id,:learning_plan_id
    rename_column :courses,:delete_topics_count,:topics_count
    rename_column :curriculums,:delete_topics_count,:topics_count
    remove_column :customized_tutorials,:topics_count

  end
end
