require 'test_helper'

module LiveStudio
  class CourseCurrentLessonTest < ActionDispatch::IntegrationTest
    self.use_transactional_fixtures = false
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

    test "student watch play when current lesson status changed" do
      course = live_studio_courses(:course_with_junior_teacher)
      visit chat.finish_live_studio_course_teams_path(course)
      LiveService::LessonDirector.new(course.current_lesson).lesson_start

      course.reload
      course.current_lesson.reload

      # assert page.has_content?('直播中'), '直播状态显示不正确'

      course.current_lesson.pause!
      sleep 3
      visit live_studio.play_course_path(course)
      page.execute_script("$.getScript( 'refresh_current_lesson', function( data, textStatus, jqxhr ) {});")

      assert page.has_content?('暂停中'), '直播状态显示不正确'
    end
  end
end
