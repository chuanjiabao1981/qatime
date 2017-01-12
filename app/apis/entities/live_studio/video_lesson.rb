module Entities
  module LiveStudio
    class VideoLesson < Grape::Entity
      expose :id do |lesson|
        lesson.id
      end
      expose :playable do |lesson|
        lesson.try(:channel_videos).present?
      end
      expose :total_play_times do |lesson|
        0
      end
      expose :user_playable do |lesson|
        true
      end
      expose :user_play_times do |lesson|
        0
      end
      expose :replays, using: Entities::LiveStudio::ChannelVideo do |lesson|
        lesson.channel_videos
      end
    end
  end
end
