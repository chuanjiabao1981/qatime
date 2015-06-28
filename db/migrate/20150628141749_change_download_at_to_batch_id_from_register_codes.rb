class ChangeDownloadAtToBatchIdFromRegisterCodes < ActiveRecord::Migration
  def change
    rename_column :register_codes, :download_at, :batch_id
  end
end
