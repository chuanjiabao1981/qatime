class AddAppidAndUnionidAndNicknameToQawechatWechatUsers < ActiveRecord::Migration
  def change
    add_column :qawechat_wechat_users, :appid, :string
    add_column :qawechat_wechat_users, :unionid, :string
    add_column :qawechat_wechat_users, :nickname, :string
    add_column :qawechat_wechat_users, :headimgurl, :string
  end
end
