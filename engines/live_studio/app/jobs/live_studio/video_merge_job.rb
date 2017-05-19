# 录制视频合并
module LiveStudio
  class VideoMergeJob < ActiveJob::Base
    queue_as :live_studio

    def perform(replay_id)
      LiveStudio::Replay.find(replay_id).merge_video
    end
  end
end
