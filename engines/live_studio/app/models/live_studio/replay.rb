module LiveStudio
  class Replay < ActiveRecord::Base
    belongs_to :lesson
    belongs_to :channel
    serialize :vids, Array

    enum video_for: { board: 0, camera: 1 }
    enum status: {
      merging: 0,
      merged: 1
    }

    after_create :merge_video
    def merge_video
      if vids.count > 1
        merge_task
      else
        single_merge
      end
    end

    def video_get
      return unless vid.present? && merged?
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

    private

    def merge_task
      VCloud::Service.app_video_merge(outputName: lesson.replay_name(video_for), vidList: vids)
    end

    def single_merge
      video = ChannelVideo.find_by(vid: vids.first)
      update(video.slice(:vid, :orig_video_key, :uid))
      video_get
      merged!
      lesson.merged!
    end
  end
end
