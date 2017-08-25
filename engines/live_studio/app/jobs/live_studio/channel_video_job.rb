module LiveStudio
  # 视频录制处理任务
  class ChannelVideoJob < ActiveJob::Base
    queue_as :live_studio

    def perform(id, action)
      LiveStudio::ChannelVideo.find(id).send(action)
    end
  end
end
