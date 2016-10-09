require 'test_helper'

module LiveServiceTest
  class CourseNotificationSenderTest < ActiveJob::TestCase
    test 'send course start notification to teacher and students' do
      @course = live_studio_courses(:course_start_at_today)
      @teacher = users(:teacher1)
      @student = users(:student2)

      assert_enqueued_jobs 1 do
        assert_enqueued_with(job: NotificationSenderJob) do
          LiveService::CourseNotificationSender.new(@course).notice(:start)
        end
      end

      assert_difference("LiveStudioCourseNotification.where(action_name: :start).count", 4, "辅导班开课通知人数不正确") do
        assert_difference("@teacher.reload.notifications.count", 1, "老师收到的通知数量不正确") do
          assert_difference("@student.reload.notifications.count", 1, "学生收到的通知数量不正确") do
            NotificationSenderJob.perform_now("LiveService::CourseNotificationSender", :start, @course)
          end
        end
      end
    end
  end
end
