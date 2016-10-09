module LiveStudio
  class LessonPlayRecordJob < ActiveJob::Base
    queue_as :live_studio

    def perform(lesson_id)
      LiveStudio::Lesson.find(lesson_id).instance_play_records(true)
    end
  end
end
