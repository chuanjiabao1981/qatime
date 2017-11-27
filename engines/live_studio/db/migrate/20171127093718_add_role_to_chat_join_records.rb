class AddRoleToChatJoinRecords < ActiveRecord::Migration
  def change
    add_column :chat_join_records, :role, :integer, default: 0
  end
end
