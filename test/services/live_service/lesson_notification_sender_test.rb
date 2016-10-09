require 'test_helper'

module LiveServiceTest
  class LessonNotificationSenderTest < ActiveJob::TestCase
    test 'send lesson start notification to teacher' do
      @lesson = live_studio_lessons(:lesson_for_start_at_today1)
      @teacher = users(:teacher1)
      assert_enqueued_jobs 1 do
        assert_enqueued_with(job: NotificationSenderJob) do
          LiveService::LessonNotificationSender.new(@lesson).notice(:start_for_teacher)
        end
      end

      assert_difference("LiveStudioLessonNotification.where(action_name: :start_for_teacher).count", 1, "课程上课通知教师人数不正确") do
        assert_difference("@teacher.reload.notifications.count", 1, "老师收到的通知数量不正确") do
          NotificationSenderJob.perform_now("LiveService::LessonNotificationSender", :start_for_teacher, @lesson)
        end
      end
    end

    test 'send lesson start notification to student' do
      @lesson = live_studio_lessons(:lesson_for_start_at_today1)
      @student = users(:student2)
      assert_enqueued_jobs 1 do
        assert_enqueued_with(job: NotificationSenderJob) do
          LiveService::LessonNotificationSender.new(@lesson).notice(:start_for_student)
        end
      end

      assert_difference("LiveStudioLessonNotification.where(action_name: :start_for_student).count", 3, "课程上课通知学生人数不正确") do
        assert_difference("@student.reload.notifications.count", 1, "学生收到的通知数量不正确") do
          NotificationSenderJob.perform_now("LiveService::LessonNotificationSender", :start_for_student, @lesson)
        end
      end
    end
  end
end
