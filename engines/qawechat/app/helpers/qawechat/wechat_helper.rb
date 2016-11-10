require 'digest/sha1'

module Qawechat
  module WechatHelper
    def get_notification_href(id, openid)
      host = WECHAT_CONFIG['domain_name']
      url = "http://#{host}/notifications/#{id}"
      return get_href(url, openid, '点击查看')
    end

    def get_customized_course_href(id, openid, text)
      host = WECHAT_CONFIG['domain_name']
      url = "http://#{host}/customized_courses/#{id}"
      return get_href(url, openid, text)
    end

    def get_user_from_wechat(params = {})
      #login in by wechat remember_token
      unless cookies[:remember_token_wechat].nil?
        remember_token = User.digest(cookies[:remember_token_wechat])
        user =  get_user_by_wechat_user(Qawechat::WechatUser.find_by(remember_token: remember_token))
        return user unless user.nil?
      end
      #login in by signature url
      if params.has_key?("noncestr") && params.has_key?("timestamp") \
        && params.has_key?("signature") && params.has_key?("openid")
        params_sig = {
            noncestr: params[:noncestr],
            timestamp: params[:timestamp],
            openid: params[:openid],
            wechat_token: ENV["WECHAT_TOKEN"]
        }
        if signature(params_sig) == params[:signature]
          wechat_user = Qawechat::WechatUser.find_by(openid: params[:openid])
          user = get_user_by_wechat_user(wechat_user)
          unless user.nil?
            sign_in_by_wechat(wechat_user)
            return user
          end
        end
      end

      return nil
    end

    private
    def get_href(url, openid, text)
      params = {
          noncestr: SecureRandom.urlsafe_base64(16),
          timestamp: Time.now.to_i,
          openid: openid,
          wechat_token: ENV["WECHAT_TOKEN"]
      }
      host = ENV["WECHAT_NOTIFICATION_HOST"]
      url_s = "#{url}?noncestr=#{params[:noncestr]}" +
          "&timestamp=#{params[:timestamp]}&signature=#{signature(params)}" +
          "&openid=#{openid}"
      href = '<a href="' + url_s + '">' + text +'</a>'
      return href
    end

    def signature(params)
      pairs = params.keys.sort.map do |key|
        "#{key}=#{params[key]}"
      end
      sig = Digest::SHA1.hexdigest pairs.join('&')
      return sig
    end

    def sign_in_by_wechat(wechat_user)
      #delete website cookies
      cookies.delete(:remember_token)
      cookies.delete(:remember_user_type)
      #set wechat cookies
      remember_token = User.new_remember_token
      cookies.permanent[:remember_token_wechat]      = remember_token
      wechat_user.update_attribute(:remember_token, User.digest(remember_token))
    end

    def get_user_by_wechat_user(wechat_user)
      unless wechat_user.nil?
        user = User.find(wechat_user.user_id)
        unless user.nil?
          #只支持老师和学生
          return Teacher.find(wechat_user.user_id) if user.teacher?
          return Student.find(wechat_user.user_id) if user.student?
        end
      end

      return nil
    end

  end
end
