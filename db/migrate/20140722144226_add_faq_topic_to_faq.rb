class AddFaqTopicToFaq < ActiveRecord::Migration
  def change
    add_column :faqs, :faq_topic_id, :integer
  end
end