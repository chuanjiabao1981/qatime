class AddDownloadAtToRegisterCodes < ActiveRecord::Migration
  def change
    add_column :register_codes, :download_at,:timestamp
  end
end
