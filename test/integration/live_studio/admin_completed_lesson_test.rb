require 'test_helper'

module LiveStudio
  class AdminCompletedLessonTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @admin = users(:admin)
      log_in_as(@admin)
    end

    def teardown
      logout_as(@admin)
      Capybara.use_default_driver
    end

    test "admin completed a lesson" do
      teacher = users(:english_teacher)
      course = live_studio_courses(:course_with_lessons)
      lesson = live_studio_lessons(:english_lesson2_finished)
      visit live_studio.teacher_course_path(teacher, course, index: :list)
      click_on "结算课程"

      lesson.reload
      assert_equal('completed', lesson.status, '结算课程错误')
    end
  end
end
