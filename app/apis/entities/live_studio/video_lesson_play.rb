module Entities
  module LiveStudio
    class VideoLessonPlay < Grape::Entity
      expose :id
      expose :name
      expose :real_time
      expose :quote, as: :video, using: Entities::Resource::VideoQuote
    end
  end
end
