module UserService
  class WechatApi
    def initialize(code, platform = 'web')
      @code = code
      @platform = platform
      @appid = WechatSettings.login.send(platform).appid
      @secret = WechatSettings.login.send(platform).secret
    end

    # 微信扫码登陆第二部
    # 获取token
    # 返回微信用户
    def web_access_token
      req = Typhoeus::Request.new(
        web_access_token_url,
        method: :get
      )
      flag = JSON.parse req.run.body
      Rails.logger.info '*****微信返回结果****'
      Rails.logger.info flag
      if flag["openid"].present?
        openid = flag["openid"]
        @wechat_user = ::Qawechat::WechatUser.find_or_create_by(openid: openid)
        info = UserService::WechatApi.wechat_userinfo(flag["access_token"], openid)
        @wechat_user.update(userinfo: userinfo(flag, info), appid: @appid,
                            unionid: info['unionid'], nickname: info['nickname'],
                            headimgurl: info['headimgurl'])
      end
      @wechat_user
    end

    class << self
      # 根据openid 绑定用户
      def binding_user(openid, user, info_update = false)
        wechat_user = ::Qawechat::WechatUser.find_by(openid: openid)
        return if wechat_user.blank?
        wechat_user.update(user_id: user.id)
        # 使用微信用户资料更新用户信息
        if info_update && wechat_user.userinfo['info'].present?
          wechat_info = wechat_user.userinfo['info']
          user.name = wechat_info['nickname']
          user.gender = wechat_info['sex']
          relative_path = Util.img_url_save_to_tmp(wechat_info['headimgurl'])
          tmp_path = Rails.root.join(relative_path)
          File.open(tmp_path) do |file|
            user.avatar = file
          end
          user.save
        end
      end

      # 获取微信用户基本信息
      def wechat_userinfo(access_token, openid)
        req = Typhoeus::Request.new(
          "https://api.weixin.qq.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}",
          method: :get,
        )
        JSON.parse req.run.body
      end

      # 微信登陆链接
      def wechat_url(state='wwtd')
        return if WECHAT_CONFIG['web_appid'].blank?
        redirect_uri = "#{WECHAT_CONFIG['host']}/wechat/login_callback"
        host = "https://open.weixin.qq.com/connect/oauth2/authorize"
        "#{host}?appid=#{WECHAT_CONFIG['web_appid']}&redirect_uri=#{redirect_uri}&response_type=code&scope=snsapi_login&state=#{state}"
      end
    end

    private
    def userinfo(credentials, info)
      {
        provider: 'wechat',
        uid: info["openid"],
        credentials: credentials,
        info: info
      }
    end

    def web_access_token_url
      "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{@appid}&secret=#{secret}&code=#{@code}&grant_type=authorization_code"
    end

    def app_id
      @appid
    end

    def secret
      @secret
    end
  end
end
