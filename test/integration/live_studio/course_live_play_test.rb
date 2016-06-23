require 'test_helper'

module LiveStudio
  class CourseLivePlayTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = ::Student.find(users(:student_one_with_course).id)
      log_in_as(@student)
    end

    def teardown
      logout_as(@student)
      Capybara.use_default_driver
    end

    test "student watch play" do
      course = live_studio_courses(:course_with_lesson)
      lesson = live_studio_lessons(:lesson_three)
      channel = live_studio_channels(:three)

      visit live_studio.play_course_lesson_path(course, lesson)

      page.has_content? channel.name

    end
  end
end
