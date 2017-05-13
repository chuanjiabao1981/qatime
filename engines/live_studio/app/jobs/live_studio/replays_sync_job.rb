# 录制视频同步
module LiveStudio
  class ReplaysSyncJob < ActiveJob::Base
    queue_as :live_studio

    def perform(recorable_type, recorable_id)
      recorable_type.constantize.find(recorable_id).fetch_replays
    end
  end
end
