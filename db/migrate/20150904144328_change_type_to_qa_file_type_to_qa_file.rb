class ChangeTypeToQaFileTypeToQaFile < ActiveRecord::Migration
  def change
    rename_column :qa_files, :type, :qa_file_type
  end
end
