module Chat
  class Account < ActiveRecord::Base

    NETEASE_HOST = 'https://api.netease.im'.freeze

    belongs_to :user, class_name: '::User'
    has_one :join_record

    after_create :set_chat_account

    def set_chat_account #创建云信ID
      res = ::Typhoeus.post(
        "#{NETEASE_HOST}/nimserver/user/create.action",
        headers: vcloud_headers,
        body: {
          accid: accid,
          name: user.nick_name
        }.to_json
      )
      return unless res.success?

      result = JSON.parse(res.body).symbolize_keys

      if result[:code] == 200
        result[:info].symbolize_keys
        result[:info][:username] = result[:info][:name]
        result[:info].delete(:name)
        self.update_columns(result[:info])
      end
    end

    def update_chat_account #云信ID更新
      res = ::Typhoeus.post(
        "#{NETEASE_HOST}/nimserver/user/update.action",
        headers: vcloud_headers,
        body: {
          accid: accid
        }.to_json
      )
    end

    def refresh_token #更新并获取新token
      res = ::Typhoeus.post(
        "#{NETEASE_HOST}/nimserver/user/refreshToken.action",
        headers: vcloud_headers,
        body: {
          accid: accid
        }.to_json
      )

      return unless res.success?

      result = JSON.parse(res.body).symbolize_keys
      self.update_columns(result[:info].symbolize_keys) if result[:code] == 200
    end

    private

    def vcloud_headers
      app_secret = NETEASE_CONFIG['AppSecret']
      nonce = SecureRandom.hex 16
      cur_time = Time.now.utc.to_i.to_s

      check_sum = Digest::SHA1.hexdigest(app_secret + nonce + cur_time)

      {
        AppKey: NETEASE_CONFIG['AppKey'],
        Nonce: nonce,
        CurTime: cur_time,
        CheckSum: check_sum,
        'Content-Type' => "application/x-www-form-urlencoded;charset=utf-8"
      }
    end

  end
end
