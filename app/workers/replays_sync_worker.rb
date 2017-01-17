# 录制视频同步
class ReplaysSyncWorker
  include Sidekiq::Worker

  # 更新辅导班录制视频列表
  def perform(lesson_id)
    lesson = LiveStudio::Lesson.find(lesson_id)
    lesson.synced! if lesson.sync_replays
  end
end
