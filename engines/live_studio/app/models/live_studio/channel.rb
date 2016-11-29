module LiveStudio
  class Channel < ActiveRecord::Base
    has_soft_delete

    VCLOUD_HOST = 'https://vcloud.163.com'.freeze

    belongs_to :course
    has_many :push_streams, dependent: :destroy
    has_many :pull_streams, dependent: :destroy

    enum use_for: { board: 0, camera: 1 }

    def sync_streams
      delete_remote_channel
      create_remote_channel
    end

    private

    after_create :create_remote_channel
    after_destroy :delete_remote_channel

    def create_remote_channel
      return build_streams if Rails.env.development? || Rails.env.testing?
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
      self.remote_id = result[:ret]["cid"]
      save!
    end

    def build_streams(result={})
      if Rails.env.production? || Rails.env.test?
        push_streams.create(address: result['pushUrl'], protocol: 'rtmp')
        pull_streams.create(address: result['rtmpPullUrl'], protocol: 'rtmp')
        pull_streams.create(address: result['hlsPullUrl'], protocol: 'hls')
        pull_streams.create(address: result['httpPullUrl'], protocol: 'http')
      elsif use_for == 'board'
        push = 'rtmp://pa0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419?wsSecret=a3c84d0ecfdeb7434ffaa534607b9e8f&wsTime=1471330308'
        pull = 'rtmp://va0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419'
        hls_pull = 'http://pullhlsa0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97/playlist.m3u8'
        http_pull = 'http://va0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97.flv?netease=va0a19f55.live.126.net'
        push_streams.create(address: push, protocol: 'rtmp')
        pull_streams.create(address: pull, protocol: 'rtmp')
        pull_streams.create(address: hls_pull, protocol: 'hls')
        pull_streams.create(address: http_pull, protocol: 'http')
      else
        push = 'rtmp://pa0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97?wsSecret=74c57894244754864cd0f07cc25ba4be&wsTime=1477448251'
        pull = 'rtmp://va0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97'
        hls_pull = 'http://pullhlsa0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97/playlist.m3u8'
        http_pull = 'http://va0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97.flv?netease=va0a19f55.live.126.net'
        push_streams.create(address: push, protocol: 'rtmp')
        pull_streams.create(address: pull, protocol: 'rtmp')
        pull_streams.create(address: hls_pull, protocol: 'hls')
        pull_streams.create(address: http_pull, protocol: 'http')
      end
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
