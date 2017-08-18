module LiveStudio
  class ChannelVideo < ActiveRecord::Base
    TOTAL_REPLAY = Rails.env.test? ? 2 : 10

    enum video_for: { board: 0, camera: 1 }

    belongs_to :channel
    belongs_to :lesson
    belongs_to :target, polymorphic: true

    # 合并回调
    def merge_callback(params = {})
      return unless params['channelid'] == channelid
      return unless params['type'].downcase == 'flv'
      with_lock do
        self.vid = params['vid']
        self.name = params['filename']
        self.orig_url = params['url']
        save!
      end
      # 设置转码任务
      async_transcode
    end

    # 视频格式转换
    # flv转mp4
    def transcode
      VCloud::Service.app_vod_transcode_resetmulti(
        {
          vids: [vid]
        },
        AppSecret: app_secret,
        AppKey: app_key
      )
    end

    # 异步转码
    def async_transcode
      ChannelVideoJob.perform_later(id, 'transcode')
    end

    def transcode_callback
      video_get
      Replay.create_from(self)
    end

    private

    after_create :video_get
    def video_get
      return if vid.blank?
      res = VCloud::Service.app_vod_video_get({ vid: vid }, AppKey: app_key, AppSecret: app_secret)
      result = JSON.parse(res.body).symbolize_keys[:ret].symbolize_keys
      update(
        duration: result[:duration],
        type_id: result[:typeId],
        snapshot_url: result[:snapshotUrl],
        orig_url: result[:origUrl],
        download_orig_url: result[:downloadOrigUrl],
        initial_size: result[:initialSize],
        sd_mp4_url: result[:sdMp4Url],
        download_sd_mp4_url: result[:downloadSdMp4Url],
        sd_mp4_size: result[:sdMp4Size],
        hd_mp4_url: result[:hdMp4Url],
        download_hd_mp4_url: result[:downloadHdMp4Url],
        hd_mp4_size: result[:hdMp4Size],
        shd_mp4_url: result[:shdMp4Url],
        download_shd_mp4_url: result[:downloadShdMp4Url],
        shd_mp4_size: result[:shdMp4Size],
        create_time: result[:createTime]
      )
    end

    before_create :set_app_info
    def set_app_info
      app = target.is_a?(LiveStudio::InteractiveLesson) ? NeteaseSettings : VCloud
      self.app_key = app.app_key
      self.app_secret = app.app_secret
    end

    # 视频合并
    after_commit :merge_to, on: :create
    def merge_to
      return if vid.blank?
      return if target.is_a?(InteractiveLesson)
      replay = target.instance_replays
      replay.with_lock do
        replay.vids.push(vid)
        replay.pending_vids.push(vid.to_s)
        replay.save
        replay.async_merge_video
      end
    end
  end
end
