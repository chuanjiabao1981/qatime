class LessonFinishWorker
  include Sidekiq::Worker

  def perform
    lessons = LiveStudio::Lesson.unfinish
  end

  private
  def finish_all(lessons)
    lessons.each do |lesson|
      if lesson.teaching?
        lesson.finish!
        lesson.
      end
    end
  end
end