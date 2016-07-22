require 'test_helper'

module LiveStudio
  class CourseLivePlayTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:student_tally)
      @course = live_studio_courses(:course_with_junior_teacher)

      LiveService::ChatAccountFromUser.new(@student).instance_account(true)
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

    test "student watch play" do
      visit chat.finish_live_studio_course_teams_path(@course)
      @course.reload

      visit live_studio.play_course_path(@course)

      page.has_content? @course.name
      page.has_selector?('div#my-video')
    end
  end
end
