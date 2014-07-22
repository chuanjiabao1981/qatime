class CreateFaqTopics < ActiveRecord::Migration
  def change
    create_table :faq_topics do |t|
      t.string :title
      t.string :user_type

      t.timestamps
    end
  end
end
