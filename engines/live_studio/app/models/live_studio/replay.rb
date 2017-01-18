module LiveStudio
  class Replay < ActiveRecord::Base
    belongs_to :lesson
    belongs_to :channel
    serialize :vids, Array

    enum video_for: { board: 0, camera: 1 }

    after_create :merge_video
    def merge_video
      return unless vids.count > 1
      VCloud::Service.app_video_merge(outputName: lesson.replay_name(video_for), vidList: vids)
    end
  end
end
