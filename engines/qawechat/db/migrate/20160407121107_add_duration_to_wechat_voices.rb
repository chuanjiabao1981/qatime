class AddDurationToWechatVoices < ActiveRecord::Migration
  def change
    add_column :qawechat_wechat_voices, :duration, :integer
  end
end
