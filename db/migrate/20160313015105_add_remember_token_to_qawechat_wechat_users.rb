class AddRememberTokenToQawechatWechatUsers < ActiveRecord::Migration
  def change
    add_column :qawechat_wechat_users, :remember_token, :string
  end
end
