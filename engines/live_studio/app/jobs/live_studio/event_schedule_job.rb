module LiveStudio
  class EventScheduleJob < ActiveJob::Base
    queue_as :live_studio

    def perform(id, action, *args)
      event = LiveStudio::Event.find(id)
      LiveStudio::EventDirector.new(event).send(action, *args)
    end
  end
end
