class ChangeAliasTypeForPushMessages < ActiveRecord::Migration
  def change
      change_column :push_messages, :alias_type, :string
      remove_column :push_messages, :production_mode
      add_column :push_messages, :production_mode, :boolean, default: true
  end
end
