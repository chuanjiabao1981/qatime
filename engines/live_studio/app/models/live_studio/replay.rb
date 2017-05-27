module LiveStudio
  class Replay < ActiveRecord::Base
    belongs_to :lesson
    belongs_to :channel
    serialize :vids, Array
    serialize :pending_vids, Array

    enum video_for: { board: 0, camera: 1 }
    enum status: {
      merging: 0,
      merged: 1
    }

    after_commit :async_merge_video, on: :create
    def merge_video
      return single_merge unless vids.count > 1 # 不需要合并
      self.pending_vids = vids
      save!
      async_merge_replays
    end

    def async_merge_video
      VideoMergeJob.perform_later(id)
    end

    def video_get
      return unless vid.present? && merging?
      res = VCloud::Service.app_vod_video_get(vid: vid)
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

    # 返回下一次合并视频ID
    def shift_pending_vids!
      pending_vids.unshift(vid) if vid && pending_vids.exclude?(vid)
      pending_vids.shift(3)
    end

    # 异步合并视频片段
    def async_merge_replays
      ReplaysMergeJob.perform_later(id)
    end

    # 合并视频片段
    def merge_replays
      return if pending_vids.blank?
      self.name = "#{name}_#{vid}" if vid && !name.end_with?("_#{vid}")
      vid_list = shift_pending_vids!
      save!
      VCloud::Service.app_video_merge(outputName: name, vidList: vid_list)
    end

    # 合并回调
    def merge_callback(params)
      with_lock do
        return unless params[:video_name] == name
        self.vid = params['vid']
        self.orig_video_key = params['orig_video_key']
        self.uid = params['uid']
        self.n_id = params['nID']
        save!
      end
      if pending_vids.blank? # 合并完成
        finish_merge
      else
        async_merge_replays
      end
    end

    private

    def single_merge
      video = ChannelVideo.find_by(vid: vids.first)
      update(video.slice(:vid, :orig_video_key, :uid))
      video_get
      merged!
      lesson.merged!
    end

    # 完成合并
    def finish_merge
      video_get
      merged!
      lesson.merged!
    end
  end
end
