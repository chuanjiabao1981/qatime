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
      new_logout_as(@teacher)
      Capybara.use_default_driver
    end

    # 暂时不能删除
    # test 'course destroy notification test' do
    #   course = live_studio_courses(:course_for_destroy)
    #   click_on "消息中心"
    #   click_on "我的辅导"
    #   assert_difference '@teacher.notifications.unread.count', -2 do
    #     click_link "delete-#{course.id}"
    #     click_on "确认"
    #   end
    #   click_on "消息中心"
    # end
  end
end
