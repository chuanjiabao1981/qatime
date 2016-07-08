module Chat
  class Account < ActiveRecord::Base

    NETEASE_HOST = 'https://api.netease.im'.freeze

    belongs_to :user, class_name: '::User'
    has_one :join_record

    after_create :set_chat_account

    def self.create_by_user(user)
      user.create_chat_account(
        accid: SecureRandom.hex(16)
      )
    end

    def set_chat_account #创建云信ID
      res = ::Typhoeus.post(
        "#{NETEASE_HOST}/nimserver/user/create.action",
        headers: netease_headers,
        body: %Q{accid=#{accid}&name=#{user.nick_name}}
      )
      return unless res.success?

      result = JSON.parse(res.body).symbolize_keys

      if result[:code] == 200
        self.update_columns(result[:info].symbolize_keys)
      end
    end

    def update_chat_account #云信ID更新
      res = ::Typhoeus.post(
        "#{NETEASE_HOST}/nimserver/user/update.action",
        headers: netease_headers,
        body: %Q{accid=#{accid}}
      )
    end

    def refresh_token #更新并获取新token
      res = ::Typhoeus.post(
        "#{NETEASE_HOST}/nimserver/user/refreshToken.action",
        headers: netease_headers,
        body: %Q{accid=#{accid}}
      )

      return unless res.success?

      result = JSON.parse(res.body).symbolize_keys
      self.update_columns(result[:info].symbolize_keys) if result[:code] == 200
    end

    def update_uinfo #更新用户名片
      update_data = %Q{accid=#{accid}&name=#{user.nick_name}}

      res = ::Typhoeus.post(
        "#{NETEASE_HOST}/nimserver/user/updateUinfo.action",
        headers: netease_headers,
        body: update_data
      )
      result = JSON.parse(res.body).symbolize_keys

      raise ActiveRecord::Rollback unless res.success? && result[:code] == 200
    end

    def get_uinfo #获取用户名片
      res = ::Typhoeus.post(
        "#{NETEASE_HOST}/nimserver/user/getUinfos.action",
        headers: netease_headers,
        body: %Q{accids=['#{accid}']}
      )
      result = JSON.parse(res.body).symbolize_keys
    end

    private

    def netease_headers
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
