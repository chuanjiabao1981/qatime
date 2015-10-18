class AddTypeToTopicAndReply < ActiveRecord::Migration
  def change
    add_column :topics,:type,:string
    add_column :replies,:type,:string
    add_column :topics,:customized_tutorial_id,:integer
    drop_table :tutorial_issues
  end
end
