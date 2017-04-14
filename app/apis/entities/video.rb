module Entities
  class Video < Grape::Entity
    expose :id
    expose :token
    expose :video_type
    expose :duration
    expose :tmp_duration
    expose :format_tmp_duration
    expose :capture do |video|
      video.try(:capture_url)
    end
  end
end
