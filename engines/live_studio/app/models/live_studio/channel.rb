module LiveStudio
  class Channel < ActiveRecord::Base
    has_soft_delete

    belongs_to :channelable, polymorphic: :true
    has_many :channel_videos, dependent: :destroy
    has_many :push_streams, dependent: :destroy
    has_many :pull_streams, dependent: :destroy

    enum use_for: { board: 0, camera: 1 }

    def sync_streams
      delete_remote_channel
      create_remote_channel
    end

    # 同步视频
    def sync_video_for(recordable)
      res = VCloud::Service.vod_video_list(cid: remote_id,
                                           beginTime: recordable.replays_start_at,
                                           endTime: recordable.replays_end_at)
      result = JSON.parse(res.body).symbolize_keys[:ret]
      result['videoList'].each do |v|
        next if channel_videos.find_by(vid: v['vid'])
        next if !Rails.env.test? && !v['name'].include?(record_filename(recordable))
        channel_videos.create(name: v['name'],
                              url: v['url'],
                              vid: v['vid'],
                              begin_time: v['beginTime'],
                              end_time: v['endTime'],
                              lesson_id: recordable.id,
                              target: recordable,
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
      return id.to_s unless recordable
      "#{recordable.record_filename}#{use_for}"
    end

    private

    after_create :create_remote_channel
    after_destroy :delete_remote_channel

    def create_remote_channel
      res = VCloud::Service.app_channel_create(name: channel_name, type: 0)
      result = JSON.parse(res.body).symbolize_keys
      build_streams(result[:ret]) if result[:code] == 200
      self.remote_id = result[:ret]["cid"]
      set_always_record
      save!
    end

    # 设置录播
    def set_always_record
      return unless remote_id.present?
      record_for(nil)
      self.set_always_recorded = true
    end

    def build_streams(result = {})
      push_streams.create(address: result['pushUrl'], protocol: 'rtmp')
      pull_streams.create(address: result['rtmpPullUrl'], protocol: 'rtmp')
      pull_streams.create(address: result['hlsPullUrl'], protocol: 'hls')
      pull_streams.create(address: result['httpPullUrl'], protocol: 'http')
    end

    def delete_remote_channel
      return unless remote_id.present?
      VCloud::Service.app_channel_delete(cid: remote_id)
    end

    def channel_name
      return name if Rails.env.production?
      "#{Rails.env} - #{name.to(6)}"
    end
  end
end
