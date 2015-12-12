class ChangeStatusDefaultValueFromCorrection < ActiveRecord::Migration
  def change
    change_column :corrections, :status, :string, :null => false, :default => "open"
  end
end
