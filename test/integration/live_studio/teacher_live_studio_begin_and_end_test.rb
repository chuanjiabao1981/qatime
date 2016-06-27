require 'test_helper'

module LiveStudio
  class TeacherLiveStudioBeginAndEndTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @teacher = users(:teacher_one)
      log_in_as(@teacher)
    end

    def teardown
      logout_as(@teacher)
      Capybara.use_default_driver
    end

    test "teacher begin and end live_studio" do
      course = live_studio_courses(:course_with_lesson)
      lesson = live_studio_lessons(:lesson_three)

      visit live_studio.teacher_course_path(course)
      page.has_content? "开始直播"
      click_on '开始直播'

      visit live_studio.teacher_course_path(course)
      page.has_content? "结束直播"
      click_on '结束直播'
    end

  end
end
