module LiveStudio
  class Channel < ActiveRecord::Base
    belongs_to :course

    has_many :streams

    def sync_streams
      self.send :delete_remote_channel
      self.send :create_remote_channel
    end

    private
    after_create :create_remote_channel
    after_destroy :delete_remote_channel

    def set_remote_channel_request_params
      @app_key = VCLOUD_CONFIG['AppKey']
      @app_secret = VCLOUD_CONFIG['AppSecret']
      @nonce = SecureRandom.hex 32
      @cur_time = Time.now.utc.to_i.to_s

      @check_sum = Digest::SHA1.hexdigest(@app_secret + @nonce + @cur_time)
    end

    def create_remote_channel
      set_remote_channel_request_params

      res = ::Typhoeus.post(
              "https://vcloud.163.com/app/channel/create",
              headers: {
                AppKey: @app_key,
                Nonce: @nonce,
                CurTime: @cur_time,
                CheckSum: @check_sum,
                'Content-Type'=> "application/json;charset=utf-8"
              },
              body: {
                name: name,
                type: 0
              }.to_json
            )

      res = JSON.parse(res.body).symbolize_keys
      p res
      if res[:code] == 200
        _res = res[:ret].symbolize_keys
        streams.create([
          {
            address: _res[:pushUrl]
          },
          {
            address: _res[:rtmpPullUrl]
          }
        ])
        self.update_columns(remote_id: _res[:cid])
      else
        errors.add :base, res[:msg]
      end
    end

    def delete_remote_channel
      return streams.destroy_all unless remote_id.present?
      set_remote_channel_request_params

      res = ::Typhoeus.post(
              "https://vcloud.163.com/app/channel/delete",
              headers: {
                AppKey: @app_key,
                Nonce: @nonce,
                CurTime: @cur_time,
                CheckSum: @check_sum,
                'Content-Type'=> "application/json;charset=utf-8"
              },
              body: {
                name: name,
                cid: remote_id,
                type: 0
              }.to_json
            )

      _res = JSON.parse(res.body).symbolize_keys
      p _res
      if _res[:code] == 200
        streams.destroy_all
        self.update_columns(remote_id: nil)
      else
        errors.add :base, res[:msg]
      end
    end

  end
end
