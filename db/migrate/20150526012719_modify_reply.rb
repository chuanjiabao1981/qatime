class ModifyReply < ActiveRecord::Migration
  def change
    remove_column :topics , :node_name    ,:string
    remove_column :replies, :user_id      ,:integer
    add_column    :replies, :author_id    ,:integer
  end
end
