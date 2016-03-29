class CreateQawechatWechatVoices < ActiveRecord::Migration
  def change
    create_table :qawechat_wechat_voices do |t|
      t.string :name
      t.string :state
      t.timestamps null: false
    end
  end
end
