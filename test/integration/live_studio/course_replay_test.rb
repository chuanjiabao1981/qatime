require 'test_helper'

module LiveStudio
  # 视频回放测试
  class CourseReplayTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @admin = users(:admin)
      @course = live_studio_courses(:course_for_replay)
    end

    def teardown
      logout_as(@admin)
      Capybara.use_default_driver
    end

    test 'admin visit replays' do
      visit live_studio.course_path(@course)
      assert page.has_content?("观看回放")
    end
  end
end
