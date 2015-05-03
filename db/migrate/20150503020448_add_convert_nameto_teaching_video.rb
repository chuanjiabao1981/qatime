class AddConvertNametoTeachingVideo < ActiveRecord::Migration
  def change
    add_column :teaching_videos,:convert_name,:string
  end
end
