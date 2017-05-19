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
      return if Rails.env.development?
      res = VCloud::Service.app_channel_create(name: name, type: 0)
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
      VCloud::Service.app_channel_delete(name: name, cid: remote_id, type: 0)
    end
  end
end
