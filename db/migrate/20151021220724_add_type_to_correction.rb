class AddTypeToCorrection < ActiveRecord::Migration
  def change
    add_column :corrections, :type,:string
  end
end
