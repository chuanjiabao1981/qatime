class LessonPauseWorker
  include Sidekiq::Worker

  # teaching状态的lesson 超过10分钟未收到心跳请求 自动转为pause
  def perform
    LiveService::LessonDirector.pause_lessons
    LiveService::InteractiveLessonDirector.pause_lessons
    LiveService::EventDirector.pause_lessons
  end
end
