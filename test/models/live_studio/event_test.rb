require 'test_helper'

module LiveStudio
  class EventTest < ActiveSupport::TestCase
    # 开始时间
    test "event start time" do
      event = live_studio_events(:scheduled_lesson_one)
      assert_equal "18:00", event.start_time, "开始时间返回不正确"
      assert_nil live_studio_events(:invalid_offline_lesson_one).start_time, "空的开始时间计算错误"
    end

    # 技术时间
    test "event end time" do
      event = live_studio_events(:offline_lesson_one)
      assert_equal "19:00", event.end_time, "开始时间返回不正确"
    end

    # 活动时间计算
    test "calculate event time" do
      lesson = LiveStudio::ScheduledLesson.new(class_date: 3.days.since, start_at_hour: '19', start_at_min: '00', duration: 'hours_1')
      lesson.valid?
      assert_equal "#{3.days.since.to_date} 19:00:00".to_time, lesson.start_at, "开始时间计算不正确"
      assert_equal "#{3.days.since.to_date} 20:00:00".to_time, lesson.end_at, "结束时间计算不正确"
    end
  end
end
