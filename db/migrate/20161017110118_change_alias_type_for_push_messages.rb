class ChangeAliasTypeForPushMessages < ActiveRecord::Migration
  def change
    change_column :push_messages, :alias_type, :string
  end
end
