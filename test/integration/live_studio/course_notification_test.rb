require 'test_helper'

module LiveStudio
  class CourseNotificationTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @teacher = users(:teacher1)
      log_in_as(@teacher)
    end

    def teardown
      logout_as(@teacher)
      Capybara.use_default_driver
    end

    test 'course destroy notification test' do
      course = live_studio_courses(:course_for_destroy)
      visit user_notifications_path(@teacher)
      sleep(20)
      click_on "我的辅导"
      sleep(20)
      assert_difference '@teacher.notifications.unread.count', 2 do
        click_link "delete-#{course.id}"
        click_on "确定"
      end
      click_on "我的消息"
    end
  end
end
