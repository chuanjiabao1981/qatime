class LiveStudioLessonNotification < ::Notification
  ACTION_START_FOR_TEACHER = :start_for_teacher
  ACTION_START_FOR_STUDENT = :start_for_student
  ACTION_MISS_FOR_TEACHER = :miss_for_teacher # 未上课通知
  ACTION_MISS_FOR_STUDENT = :miss_for_student # 未上课通知
  ACTION_CHANGE_TIME = :change_time # 调课提醒
end
