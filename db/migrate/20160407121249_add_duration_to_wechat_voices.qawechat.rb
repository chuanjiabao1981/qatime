# This migration comes from qawechat (originally 20160407121107)
class AddDurationToWechatVoices < ActiveRecord::Migration
  def change
    add_column :qawechat_wechat_voices, :duration, :integer
  end
end
