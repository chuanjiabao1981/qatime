module LiveStudio
  class Channel < ActiveRecord::Base
    include LiveStudio::Channelable
    has_soft_delete

    belongs_to :course
    has_many :channel_videos, dependent: :destroy
    has_many :push_streams, dependent: :destroy
    has_many :pull_streams, dependent: :destroy

    enum use_for: { board: 0, camera: 1 }

    def sync_streams
      delete_remote_channel
      create_remote_channel
    end

    # 更新录制视频列表 (是否强制更新所有视频信息)
    def update_video_list(enforce = false)
      return if remote_id.blank?
      res = ::Typhoeus.post(
        "#{VCLOUD_HOST}/app/videolist",
        headers: vcloud_headers,
        body: {
          cid: remote_id
        }.to_json
      )
      return unless res.success?
      result = JSON.parse(res.body).symbolize_keys
      ChannelVideo.transaction do
        result[:ret]['videoList'].each do |rt|
          video = channel_videos.find_or_initialize_by(vid: rt['vid'])
          video.update_video_info if video.new_record? || enforce
          video.update(name: rt['video_name'], key: rt['orig_video_key'], video_for: use_for)
        end
      end
    end

    # 同步视频
    def sync_video_for(lesson)
      res = VCloud::Service.vod_video_list(cid: remote_id,
                                           beginTime: lesson.replays_start_at,
                                           endTime: lesson.replays_end_at)
      result = JSON.parse(res.body).symbolize_keys[:ret]
      result['videoList'].each do |v|
        next if channel_videos.find_by(vid: v['vid'])
        channel_videos.create(name: v['name'],
                              url: v['url'],
                              vid: v['vid'],
                              begin_time: v['beginTime'],
                              end_time: v['endTime'],
                              lesson_id: lesson.id,
                              video_for: use_for)
      end
      true
    end

    def record_for(recordable)
      VCloud::Service.app_channel_set_always_record(
        cid: remote_id,
        needRecord: 1,
        format: 0,
        duration: 120,
        filename: record_filename(recordable)
      )
    end

    # 录制文件名
    def record_filename(recordable)
      "#{recordable.record_filename}#{use_for}"
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

      set_always_record
      save!
    end

    # 设置录播
    def set_always_record
      return unless remote_id.present?
      self.set_always_recorded = always_record
    end

    def build_streams(result={})
      if Rails.env.production? || Rails.env.test?
        push_streams.create(address: result['pushUrl'], protocol: 'rtmp')
        pull_streams.create(address: result['rtmpPullUrl'], protocol: 'rtmp')
        pull_streams.create(address: result['hlsPullUrl'], protocol: 'hls')
        pull_streams.create(address: result['httpPullUrl'], protocol: 'http')
      elsif use_for == 'board'
        push = 'rtmp://pa0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419?wsSecret=16c5154fb843f7b7d2819554d8d3aa94&wsTime=1480648811'
        pull = 'rtmp://va0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419'
        hls_pull = 'http://pullhlsa0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419/playlist.m3u8'
        http_pull = 'http://va0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419.flv?netease=va0a19f55.live.126.net'
        push_streams.create(address: push, protocol: 'rtmp')
        pull_streams.create(address: pull, protocol: 'rtmp')
        pull_streams.create(address: hls_pull, protocol: 'hls')
        pull_streams.create(address: http_pull, protocol: 'http')
        self.remote_id = "2794c854398f4d05934157e05e2fe419"
        save
      else
        push = 'rtmp://pa0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97?wsSecret=f49d13a6ab68601884b5b71487ff51e1&wsTime=1480648749'
        pull = 'rtmp://va0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97'
        hls_pull = 'http://pullhlsa0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97/playlist.m3u8'
        http_pull = 'http://va0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97.flv?netease=va0a19f55.live.126.net'
        push_streams.create(address: push, protocol: 'rtmp')
        pull_streams.create(address: pull, protocol: 'rtmp')
        pull_streams.create(address: hls_pull, protocol: 'hls')
        pull_streams.create(address: http_pull, protocol: 'http')
        self.remote_id = "0ca7943afaa340c9a7c1a8baa5afac97"
        save
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

    def always_record
      VCloud::Service.app_channel_set_always_record(
        cid: remote_id,
        needRecord: 1,
        format: 0,
        duration: 120, # minutes
        filename: "#{course.name}#{id}#{use_for}"
      ).success?
    end
  end
end
