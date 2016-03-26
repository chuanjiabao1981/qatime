require_dependency "qawechat/application_controller"

module Qawechat
  class WechatVoicesController < ApplicationController
    def show
    end
    
    def create
	serverId = "#{params[:serverId]}"
	#从微信服务器下载音频
	tmp_file = Wechat.api.media(serverId)
	#生成微信服务器保存的音频的链接
	url_voice_wechat = "https://api.weixin.qq.com/cgi-bin/media/get?access_token=#{Wechat.api.access_token.token}&media_id=#{serverId}"
	puts url_voice_wechat
	render plain: "url_voice_wechat:#{url_voice_wechat};tmp_file:#{tmp_file.path}"
    end
  end
end
