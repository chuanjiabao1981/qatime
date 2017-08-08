module LiveStudio
  module Recordable
    extend ActiveSupport::Concern

    included do
      has_many :channel_videos, as: :target
    end

    def record_filename
      "#{model_name.route_key}#{id}"
    end

    # 设置录制当前对象
    def record!
      channels.map {|c| c.record_for(self) }
    end

    # 异步获取视频回放
    def async_fetch_replays
      ReplaysSyncJob.perform_later(model_name.to_s, id)
    end

    # 获取视频回放
    def fetch_replays
      channels.map {|c| c.sync_video_for(self) if c.board? }
      synced! if channel_videos.count > 0 && unsync?
    end

    # 初始化回放
    def instance_replays
      return replays.last unless replays.blank?
      replays.create!(video_for: ChannelVideo.video_fors['board'],
                      name: board_replay_name,
                      channel: board_channel)
    end

    # 查询或者创建录制视频
    def instance_videos(channel, attrs)
      video = channel_videos.find_by(vid: attrs['vid'])
      return video if video
      channel_videos.create(
        name: attrs['video_name'],
        vid: attrs['vid'],
        begin_time: attrs['beginTime'],
        end_time: attrs['endTime'],
        channel_id: channel.id,
        video_for: channel.use_for
      )
    end
  end
end
