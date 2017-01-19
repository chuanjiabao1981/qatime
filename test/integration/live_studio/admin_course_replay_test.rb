require 'test_helper'

module LiveStudio
  # 管理员视频回放测试
  class AdminCourseReplayTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @course = live_studio_courses(:course_for_replay)

      @admin = users(:admin)
      log_in_as(@admin)
    end

    def teardown
      Capybara.use_default_driver
    end

    test 'admin visit replays' do
      lesson = live_studio_lessons(:replay_lessons_1)
      visit live_studio.course_path(@course)
      assert page.has_content?("观看回放"), "辅导班详情页没有回放链接"
      visit live_studio.play_course_path(@course)
      assert page.has_content?("观看回放"), "辅导班观看页没有回放链接"
      visit live_studio.replay_lesson_path(lesson)
      click_on '退出'
    end
  end
end
