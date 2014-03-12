class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string      :title
      t.text        :body
      t.integer     :replies_count,:default=>0
      t.integer     :node_id
      t.string      :node_name
      t.integer     :user_id
      t.timestamps
    end
  end
end
