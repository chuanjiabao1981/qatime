require 'digest/sha1'

module Qawechat
  module WechatHelper
    def get_notification_href(id, openid)
      params = {
          noncestr: SecureRandom.base64(16),
          timestamp: Time.now.to_i,
          openid: openid,
          wechat_token: ENV["WECHAT_TOKEN"]
      }
      host = 'rails.wrcomputer.cn'
      url = "http://#{host}/notifications/#{id}?noncestr=#{params[:noncestr]}" +
          "&timestamp=#{params[:timestamp]}&signature=#{signature(params)}" +
          "&openid=#{openid}"

      href = '<a href="' + url + '">点击查看</a>'
      return href
    end

    def get_user_from_wechat(params = {})
      if params.size >= 4 && params.has_key?("noncestr") && params.has_key?("timestamp") \
        && params.has_key?("signature") && params.has_key?("openid")
        params_sig = {
            noncestr: params[:noncestr],
            timestamp: params[:timestamp],
            openid: params[:openid],
            wechat_token: ENV["WECHAT_TOKEN"]
        }
        if signature(params_sig) == params[:signature]
          wechat_user = Qawechat::WechatUser.find_by(openid: params[:openid])
          #只支持老师和学生
          if User.find(wechat_user.user_id).teacher?
            return Teacher.find(wechat_user.user_id)
          elsif User.find(wechat_user.user_id).student?
            return Student.find(wechat_user.user_id)
          end
        end
      end
      return nil
    end

    private
    def signature(params)
      pairs = params.keys.sort.map do |key|
        "#{key}=#{params[key]}"
      end
      sig = Digest::SHA1.hexdigest pairs.join('&')
      return sig
    end

  end
end