module Entities
  module LiveStudio
    class InteractiveLessonReplay < Grape::Entity
      expose :id
      expose :name
      expose :duration
      expose :replayable
      expose :user_playable do |lesson, options|
        lesson.replayable_for?(options[:current_user])
      end
      expose :replay, using: Entities::LiveStudio::ChannelVideo do |lesson|
        lesson.replays.board.merged.first
      end
    end
  end
end
