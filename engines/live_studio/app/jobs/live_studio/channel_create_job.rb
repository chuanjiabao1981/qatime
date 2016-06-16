module LiveStudio
  class ChannelCreateJob < ActiveJob::Base
    queue_as :live_studio

    def perform(course_id)
      Course.find(course_id).init_channel
    end
  end
end
