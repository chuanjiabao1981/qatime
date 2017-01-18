module Entities
  module LiveStudio
    class VideoLesson < Grape::Entity
      expose :id
      expose :name
      expose :duration
      expose :replayable
      expose :user_playable do |lesson|
        lesson.left_replay_times > 0
      end
      expose :user_play_times do |lesson|
        lesson.replay_times
      end
      expose :left_replay_times
      expose :replay, using: Entities::LiveStudio::ChannelVideo, if: { type: :full } do |lesson|
        lesson.replays.merged.last
      end
    end
  end
end
