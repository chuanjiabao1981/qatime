# 录制视频同步
class ReplaysSyncWorker
  include Sidekiq::Worker

  # 更新辅导班录制视频列表
  def perform(lesson_id, retry_times = 0)
    lesson = LiveStudio::Lesson.find(lesson_id)
    lesson.sync_replays
    return unless lesson.channel_videos.count > 0
    ReplaysSyncWorker.perform_async(lesson_id, retry_times + 1) if retry_times < 5
  end
end
