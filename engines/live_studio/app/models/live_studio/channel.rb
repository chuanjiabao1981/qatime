module LiveStudio
  class Channel < ActiveRecord::Base
    belongs_to :course

    has_many :streams

    private
    after_create :create_remote_channel

    def create_remote_channel
      app_secret = "95dd5b42ecd44ce9ac2225eb2c4ae6c9"
      nonce = ""
      cur_time = Time.now.utc.to_i.to_s

      check_sum = Digest::SHA1.hexdigest(app_secret + nonce + cur_time)

      Digest::SHA1.hexdigest(token.to_s)
      res = Typhoeus.post(
              "vcloud.163.com/app/channel/create",
              params: {
                name: name,
                type: 0
              },
              headers: {
                AppKey: "642a1a8174ad4094a1431eb3beda4e84",
                Nonce: nonce,
                CurTime: cur_time,
                CheckSum: check_sum,
                Content_Type: "application/json;charset=utf-8"
              }
            )

      _res = JSON.parse(res.options[:response_body]).symbolize_keys

      if _res[:code] == 200
        streams.create([
          {
            address: _res[:pushurl]
          },
          {
            address: _res[:rtmpPullUrl]
          }
        ])
      end
    end

  end
end
