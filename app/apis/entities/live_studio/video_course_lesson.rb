module Entities
  module LiveStudio
    class VideoCourseLesson < Grape::Entity
      expose :id
      expose :name
      expose :status
      expose :live_time
      expose :replayable
      expose :left_replay_times
      expose :duration
    end
  end
end
