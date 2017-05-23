module LiveStudio
  class ChannelCreateJob < ActiveJob::Base
    queue_as :live_studio

    def perform(channelable_id, channelable_type = 'LiveStudio::Course')
      channelable_type.constantize.find(channelable_id).init_channels
    end
  end
end
