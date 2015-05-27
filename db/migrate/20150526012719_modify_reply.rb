class ModifyReply < ActiveRecord::Migration
  def change
    remove_column :topics ,   :node_name    ,:string
    remove_column :replies,   :user_id      ,:integer
    add_column    :replies,   :author_id    ,:integer
    rename_column :replies,   :body         ,:content
    rename_column :topics,    :body         ,:content
    rename_column :comments,  :body         ,:content
  end
end
