class ChangeTutorial < ActiveRecord::Migration
  def change
    remove_column :tutorials,:video_id,:integer
    remove_column :tutorials,:cover_id,:integer
    add_column :videos,:tutorial_id,:integer
    add_column :covers,:tutorial_id,:integer
    add_column :tutorials,:token,:string
    add_column :videos,:token,:string
    add_column :covers,:token,:string
    add_index :tutorials,:token
    add_index :videos,:token
    add_index :covers,:token
  end
end
