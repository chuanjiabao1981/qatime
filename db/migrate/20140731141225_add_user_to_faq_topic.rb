class AddUserToFaqTopic < ActiveRecord::Migration
  def change
    add_column :faq_topics,:user_id,:integer
  end
end
