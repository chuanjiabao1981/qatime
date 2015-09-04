class AddOriginalFilenameToQaFile < ActiveRecord::Migration
  def change
    add_column :qa_files, :original_filename,:string
  end
end
