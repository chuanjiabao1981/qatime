class CreateQawechatWechatUsers < ActiveRecord::Migration
  def change
    create_table :qawechat_wechat_users do |t|
      t.string :openid
      t.text :userinfo

      t.timestamps null: false
    end
  end
end
