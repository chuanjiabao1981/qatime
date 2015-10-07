class ChangeStatusDefaultValueFromReply < ActiveRecord::Migration
  def change
    change_column :replies, :status, :string, :null => false, :default => "open"
  end
end
