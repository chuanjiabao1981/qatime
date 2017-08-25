module LiveStudio
  class ChannelCreateJob < ActiveJob::Base
    queue_as :live_studio

    # 支持GlobalID 对象传递
    def perform(channelable)
      channelable.init_channels
    end
  end
end
