module LiveStudio
  module Recordable
    extend ActiveSupport::Concern

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
      synced! if channel_videos.count > 0
      # 设置合并任务
      async_merge_replays if synced?
    end

    # 异步合并视频片段
    def async_merge_replays
      ReplaysMergeJob.perform_later(model_name.to_s, id)
    end

    # 合并视频片段
    def merge_replays
      replays.create(video_for: ChannelVideo.video_fors['board'],
                     name: board_replay_name,
                     vids: board_video_vids,
                     channel: channels.find_by(use_for: Channel.use_fors['board']))
    end
  end
end
