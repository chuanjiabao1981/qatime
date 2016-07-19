class LessonFinishWorker
  include Sidekiq::Worker

  def perform
    lessons = LiveStudio::Lesson.should_complete
    finish_all(lessons)
  end

  private
  def finish_all(lessons)
    lessons.each do |lesson|
      if lesson.teaching?
        lesson.update(live_start_at: lesson.try(:live_sessions).try(:last).try(:heartbeat_at) || lesson.live_start_at)
        LiveService::BillingDirector.new(lesson).finish_with_billing
      end
    end
  end
end