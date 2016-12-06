module UserService
  class WechatApi
    def initialize(code, platform='web')
      @code = code
      @platform = platform
    end

    # 微信扫码登陆第二部
    # 获取token
    # 返回微信用户
    def web_access_token
      request = Typhoeus::Request.new(
        web_access_token_url,
        method: :get,
      )
      flag = JSON.parse request.run.body
      if flag["openid"].present?
        openid = flag["openid"]
        @wechat_user = WechatUser.find_or_create_by(openid)
        @wechat_user.update(remember_token: flag["refresh_token"])
      end
      @wechat_user
    end

    class << self

      def binding_user(openid, user, info_update = true)
        wechat_user = ::Qawechat::WechatUser.find_by(openid: openid)
        wechat_user.update(user: user)
        # 使用微信用户资料更新用户信息
        if info_update
          # todo
        end
      end
    end

    private

    def web_access_token_url
      "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{app_id}&secret=#{secret}&code=#{@code}&grant_type=authorization_code"
    end

    def app_id
      WECHAT_CONFIG["#{@platform}_appid"]
    end

    def secret
      WECHAT_CONFIG["#{@platform}_secret"]
    end
  end
end
