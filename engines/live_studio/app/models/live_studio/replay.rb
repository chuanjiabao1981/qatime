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

    private

    def merge_task
      VCloud::Service.app_video_merge(outputName: lesson.replay_name(video_for), vidList: vids)
    end

    def single_merge
      video = ChannelVideo.find_by(vid: vids.first)
      update(video.slice(:vid, :orig_video_key, :uid))
      merged!
    end
  end
end
