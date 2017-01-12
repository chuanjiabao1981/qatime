module Entities
  module LiveStudio
    class VideoLesson < Grape::Entity
      expose :id do |lesson|
        lesson.id
      end
      expose :playable do |lesson|
        lesson.try(:channel_videos).present?
      end
      expose :total_play_times
      expose :user_playable do |lesson, options|
        lesson.play_records.replay.where(user: options[:current_user]).count < 20
      end
      expose :user_play_times do |lesson, options|
        lesson.play_records.replay.where(user: options[:current_user]).count
      end
      expose :replays, using: Entities::LiveStudio::ChannelVideo, if: { type: :full } do |lesson|
        lesson.channel_videos
      end
    end
  end
end
