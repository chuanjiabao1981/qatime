class AddVideoUrlToFaq < ActiveRecord::Migration
  def change
    add_column :faqs,:video_url,:string
  end
end
