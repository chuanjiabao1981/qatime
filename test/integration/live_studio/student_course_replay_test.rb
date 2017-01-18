require 'test_helper'

module LiveStudio
  # 管理员视频回放测试
  class StudentCourseReplayTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @course = live_studio_courses(:course_for_replay)
      @student = ::Student.find(users(:student_with_order2).id)
      new_log_in_as(@student)
    end

    def teardown
      Capybara.use_default_driver
    end

    test 'student visit replays' do
      visit live_studio.course_path(@course)
      click_on "加入试听"
      lesson = live_studio_lessons(:replay_lessons_1)
      lesson2 = live_studio_lessons(:replay_lessons_2)
      visit live_studio.course_path(@course)
      assert page.has_content?("观看回放"), "辅导班详情页没有回放链接"
      visit live_studio.play_course_path(@course)
      assert page.has_content?("观看回放"), "辅导班观看页没有回放链接"
      assert page.has_content?("剩余（0次）")
      assert page.has_content?("剩余（1次）")
      assert page.has_content?("剩余（2次）")
      visit live_studio.replay_lesson_path(lesson2)
      click_on '退出'
    end
  end
end
