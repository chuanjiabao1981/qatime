# 录制视频同步
class ReplaysMergeWorker
  include Sidekiq::Worker

  # 更新辅导班录制视频列表
  def perform(lesson_id)
    lesson = LiveStudio::Lesson.find(lesson_id)
    return unless lesson.reload.synced?
    lesson.merge_replays
    lesson.merging! if lesson.reload.synced?
  end
end
