# 录制视频合并
module LiveStudio
  class ReplaysMergeJob < ActiveJob::Base
    queue_as :live_studio

    def perform(id)
      LiveStudio::Replay.find(id).merge_replays
    end
  end
end
