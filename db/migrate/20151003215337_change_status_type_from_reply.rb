class ChangeStatusTypeFromReply < ActiveRecord::Migration
  def change
    change_column :replies, :status, :string
  end
end
