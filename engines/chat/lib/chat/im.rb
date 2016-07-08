module Chat
  class IM
    IM_HOST = 'https://api.netease.im/nimserver'.freeze
    cattr_accessor :app_key, :app_secret

    def self.config(conf)
      self.app_key = conf['app_key']
      self.app_secret = conf['app_secret']
    end

    def self.team_create(params)
      params = { magree: 0, joinmode: 2 }.merge(params)
      post_request("#{IM_HOST}/team/create.action", params)
    end

    def self.team_add(tid, owner, msg, members)
      params = { magree: 0, tid: tid, owner: owner, msg: msg, members: members }
      post_request("#{IM_HOST}/team/add.action", params)
    end

    def self.user_create
    end

    private_class_method

    def self.post_request(url, body)
      body = body.map {|k, v| "#{k}=#{v}"}.join("&") if body.is_a?(Hash)
      res = Typhoeus.post(url, headers: headers, body: body)
      return JSON.parse(res.body)['tid'] if res.success?
      Rails.logger.error("云信服务器通信错误\n#{url}\n#{body}")
      nil
    end

    def self.headers
      nonce = SecureRandom.hex 16
      cur_time = Time.now.utc.to_i.to_s
      check_sum = Digest::SHA1.hexdigest(Chat::IM.app_secret + nonce + cur_time)
      {
        AppKey: Chat::IM.app_key,
        Nonce: nonce,
        CurTime: cur_time,
        CheckSum: check_sum,
        'Content-Type' => "application/x-www-form-urlencoded;charset=utf-8"
      }
    end
  end
end
