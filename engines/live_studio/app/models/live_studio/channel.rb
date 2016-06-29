module LiveStudio
  class Channel < ActiveRecord::Base
    has_soft_delete

    VCLOUD_HOST = 'https://vcloud.163.com'.freeze

    belongs_to :course
    has_many :push_streams, dependent: :destroy
    has_many :pull_streams, dependent: :destroy

    def sync_streams
      delete_remote_channel
      create_remote_channel
    end

    private

    after_create :create_remote_channel
    after_destroy :delete_remote_channel

    def create_remote_channel
      res = ::Typhoeus.post(
        "#{VCLOUD_HOST}/app/channel/create",
        headers: vcloud_headers,
        body: {
          name: name,
          type: 0
        }.to_json
      )
      return unless res.success?
      result = JSON.parse(res.body).symbolize_keys
      build_streams(result[:ret]) if result[:code] == 200
    end

    def build_streams(result)
      push_streams.create(address: result['pushUrl'], protocol: 'rtmp')
      pull_streams.create(address: result['rtmpPullUrl'], protocol: 'rtmp')
    end

    def delete_remote_channel
      return  unless remote_id.present?
      ::Typhoeus.post(
        "#{VCLOUD_HOST}/app/channel/delete",
        headers: vcloud_headers,
        body: {
          name: name,
          cid: remote_id,
          type: 0
        }.to_json
      )
    end

    def vcloud_headers
      app_secret = VCLOUD_CONFIG['AppSecret']
      nonce = SecureRandom.hex 32
      cur_time = Time.now.utc.to_i.to_s

      check_sum = Digest::SHA1.hexdigest(app_secret + nonce + cur_time)

      {
        AppKey: VCLOUD_CONFIG['AppKey'],
        Nonce: nonce,
        CurTime: cur_time,
        CheckSum: check_sum,
        'Content-Type' => "application/json;charset=utf-8"
      }
    end
  end
end
