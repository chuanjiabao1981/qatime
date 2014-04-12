class AddTokenToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :token, :string
  end
end
