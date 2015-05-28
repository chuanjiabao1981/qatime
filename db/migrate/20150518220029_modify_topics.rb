class ModifyTopics < ActiveRecord::Migration
  def change
    add_column :courses,:topics_count,:integer,:default => 0
    add_column :curriculums,:topics_count,:integer,:default => 0
    add_column :lessons,:topics_count,:integer,:default => 0
    add_column :topics,:lesson_id,:integer
    add_column :topics,:learning_plan_id,:integer
    add_column :topics,:teacher_id,:integer
    remove_column :topics,:group_id,:integer
    remove_column :topics,:node_id,:integer
    remove_column :topics,:section_id,:integer
  end
end
