class AddUserIdToQawechatWechatUsers < ActiveRecord::Migration
  def change
    add_column :qawechat_wechat_users, :user_id, :integer
  end
end
