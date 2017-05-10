module Entities
  module LiveStudio
    class VideoCourseBase < Grape::Entity
      format_with(:local_timestamp, &:to_i)
      expose :id
      expose :name
      expose :subject
      expose :grade
      expose :teacher_name
    end
  end
end
