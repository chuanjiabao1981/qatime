class AddGroupToLesson < ActiveRecord::Migration
  def change
    add_column      :lessons,:group_id,:integer
    add_column      :lessons,:teacher_id,:integer
    remove_column   :lessons,:author_id,:integer
    remove_column   :lessons,:section_id,:integer
    remove_column   :lessons,:node_id,:integer
  end
end
