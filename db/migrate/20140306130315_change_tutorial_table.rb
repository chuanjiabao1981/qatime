class ChangeTutorialTable < ActiveRecord::Migration
  def change
    remove_column :tutorials,:video
    remove_column :tutorials,:cover
    add_column :tutorials,:video_id,:integer
    add_column :tutorials,:cover_id,:integer
  end
end
