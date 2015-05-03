class AddConvertToVideo < ActiveRecord::Migration
  def change
    add_column :videos,:convert_name,:string
    remove_column :videos,:tutorial_id,:integer
    add_column :videos,:state,:string,:default => "not_convert"
    add_column :teaching_videos,:state,:string,:default => "not_convert"
  end
end
