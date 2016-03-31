require_dependency "qawechat/application_controller"

module Qawechat
  class WechatVoicesController < ApplicationController
    def show
	puts "#{Rails.root}/engines/qawechat/test/fixtures/qawechat/voice.amr"
        result = Wechat.api.media_create("voice", "#{Rails.root}/engines/qawechat/test/fixtures/qawechat/voice.amr")
        puts "result:#{result}"

	if params[:serverId].nil?
	  render 'new'
	else
	  @serverId = params[:serverId]
	end
    end
    
    def create
	serverId = "#{params[:serverId]}"
	#从微信服务器下载音频
	tmp_file = Wechat.api.media(serverId)
	#生成微信服务器保存的音频的链接,返回的是amr格式，H5无法直接播放
	url_voice_wechat = "https://api.weixin.qq.com/cgi-bin/media/get?access_token=#{Wechat.api.access_token.token}&media_id=#{serverId}"
	puts url_voice_wechat
	render plain: "succeed"
    end
  end
end
