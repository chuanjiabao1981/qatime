# 录制视频合并
module LiveStudio
  class ReplaysMergeJob < ActiveJob::Base
    queue_as :live_studio

    def perform(recorable_type, recorable_id)
      recorable_type.constantize.find(recorable_id).merge_replays
    end
  end
end
