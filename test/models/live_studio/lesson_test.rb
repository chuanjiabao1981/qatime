require 'test_helper'

module LiveStudio
  class LessonTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    test "order lessons" do
      course = live_studio_courses(:update_course_by_physics_teacher1)
      order_lessons = course.order_lessons

      assert live_studio_lessons(:lesson3_of_update_course), order_lessons.first
    end

    # 测试同步回放视频
    test "sync replays" do
      lesson = live_studio_lesson(:finished_lesson)
      assert_difference "lesson.channel_videos.count", 2, "同步回放视频失败" do
        lesson.sync_replays
      end
      assert lesson.replayable, "没有改变视频同步状态"
    end

    # 测试回放次数
    test 'user left replay times' do
      lesson = live_studio_lesson(:finished_lesson)
      assert_equal 5, lesson.user_left_times, '剩余回放次数错误'
    end

    # 测试回放权限
    test 'replay permission' do
      lesson = live_studio_lesson(:finished_lesson)
      admin = users(:ssss)
      student_can_replay = users(:ssss)
      student_not_buy = users(:ssss)
      student_replay_use_up = users(:ssss)

      assert lesson.replayable_for(admin), "管理员观看回放失败" # 管理员可以观看回放
      assert lesson.replayable_for(student_can_replay), "学生观看回放失败" # 已经购买并且没有用完回放次数可以回放
      assert_not lesson.replayable_for(student_not_buy), "回放权限控制失效"
      assert_not lesson.replayable_for(student_replay_use_up), "回放权限控制失效"
    end

    test ''
  end
end
