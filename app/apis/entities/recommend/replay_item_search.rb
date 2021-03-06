module Entities
  module Recommend
    class ReplayItemSearch < ReplayItem
      expose :grade do |item|
        item.course.try(:grade)
      end
      expose :subject do |item|
        item.course.try(:subject)
      end
      expose :teacher_name do |item|
        item.target.try(:teacher).try(:name).presence || item.course.try(:teacher).try(:name)
      end
      expose :video_duration do |item|
        item.video.try(:duration).to_i
      end
      expose :video_url do |item|
        if item.target.is_a?(::LiveStudio::InteractiveLesson)
          item.video.try(:shd_mp4_url)
        else
          item.video.try(:orig_url)
        end
      end
    end
  end
end
