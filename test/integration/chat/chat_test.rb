require 'test_helper'

module LiveStudio
  class ChatTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:student_one_with_course)
      log_in_as(@student)
    end

    def logout_as(user)
      accept_prompt(with: "是否离开直播页面") do
        visit get_home_url(user)
      end
      click_on '退出系统'
    end

    def teardown
      logout_as(@student)
      Capybara.use_default_driver
    end

    test "student say somthing" do
      course = live_studio_courses(:course_with_lesson)

      visit live_studio.play_course_path(course)
      sleep(3)
      fill_in "message-area", with: "大家好呀"
      click_on "发送"
      sleep(10)
    end
  end
end
