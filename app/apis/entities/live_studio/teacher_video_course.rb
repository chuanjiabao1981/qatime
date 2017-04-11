module Entities
  module LiveStudio
    class TeacherVideoCourse < Entities::LiveStudio::VideoCourse
      expose :current_lesson_name, if: { type: :full }

      with_options(format_with: :local_timestamp) do
        expose :start_at, as: :preview_time
      end
    end
  end
end
