module LiveStudio
  class Channel < ActiveRecord::Base
    belongs_to :course

    has_many :streams

    private
    after_create :create_remote_channel

    def create_remote_channel
      app_key = "4777a817079249d8bbe660bd912a4285"
      app_secret = "640d551c3dd64ab88de5b63ff7b5fa6d"
      nonce = SecureRandom.hex 32
      cur_time = Time.now.utc.to_i.to_s

      check_sum = Digest::SHA1.hexdigest(app_secret + nonce + cur_time)

      res = ::Typhoeus.post(
              "https://vcloud.163.com/app/channel/create",
              headers: {
                AppKey: app_key,
                Nonce: nonce,
                CurTime: cur_time,
                CheckSum: check_sum,
                'Content-Type'=> "application/json;charset=utf-8"
              },
              body: {
                name: name,
                type: 0
              }.to_json
            )

      _res = JSON.parse(res.body).symbolize_keys

      if _res[:code] == 200
        _res = _res[:ret].symbolize_keys
        streams.create([
          {
            address: _res[:pushUrl]
          },
          {
            address: _res[:rtmpPullUrl]
          }
        ])
      end
    end

  end
end
