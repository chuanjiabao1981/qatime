require 'test_helper'

module LiveStudio
  class CourseCurrentLessonTest < ActionDispatch::IntegrationTest
    self.use_transactional_tests = false
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student_tally)
      LiveService::ChatAccountFromUser.new(@student).instance_account(true)
      log_in_as(@student)
    end

    def logout_as(user)
      accept_prompt(with: "是否离开直播页面") do
        visit get_home_url(user)
      end
      click_on '退出'
    end

    def teardown
      logout_as(@student)
      Capybara.use_default_driver
    end
  end
end
