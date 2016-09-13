require 'test_helper'

module LiveServiceTest
  class LessonNotificationSenderTest  < ActiveSupport::TestCase
    test 'send course start notification to teacher and students' do
      @lesson = live_studio_lessons(:lesson_for_start_at_today1)
      @teacher = users(:teacher1)
      @student = users(:student2)
      assert_difference("LiveStudioLessonNotification.where(action_name: :start).count", 4, "课程上课通知人数不正确") do
        assert_difference("@teacher.reload.notifications.count", 1, "老师收到的通知数量不正确") do
          assert_difference("@student.reload.notifications.count", 1, "学生收到的通知数量不正确") do
            LiveService::LessonNotificationSender.new(@lesson).notice(:start)
          end
        end
      end
    end
  end
end
