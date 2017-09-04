require 'test_helper'

module LiveStudio
  class StudentCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:student_one_with_course)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "student courses index view" do
      course = live_studio_courses(:course_preview)
      visit live_studio.student_courses_path(@student)
      page.has_content? course.name
    end

    test "student courses show view" do
      course = live_studio_courses(:course_preview)
      visit live_studio.student_course_path(@student,course)
      page.has_content? course.name
      page.has_content? course.teacher.name
      page.has_content? course.workstation.name
      page.has_content? course.description
      page.has_content? course.price
    end
  end
end
