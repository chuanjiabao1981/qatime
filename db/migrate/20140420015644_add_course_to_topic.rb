class AddCourseToTopic < ActiveRecord::Migration
  def change
    add_column      :topics,:course_id,:integer
    add_column      :topics,:group_id,:integer
    add_column      :topics,:author_id,:integer
    remove_column   :topics,:user_id,:integer
  end
end
