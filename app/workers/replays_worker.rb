class ReplaysWorkder
  include Sidekiq::Worker

  # 更新辅导班录制视频列表
  def perform(lesson_id)
    lesson = LiveStudio::Lesson.find(lesson_id)
    lesson.pull_replays
  end
end
