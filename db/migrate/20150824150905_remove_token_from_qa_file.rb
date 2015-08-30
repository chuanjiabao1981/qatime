class RemoveTokenFromQaFile < ActiveRecord::Migration
  def change
    remove_column :qa_files,:token,:string
  end
end
