require 'test_helper'

module LiveStudio
  class CourseLivePlayTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:student_one_with_course)
      log_in_as(@student)
    end

    def teardown
      logout_as(@student)
      Capybara.use_default_driver
    end

    test "student watch play" do
      teacher = users(:teacher_one)
      course = live_studio_courses(:course_with_lesson)
      ticket = live_studio_tickets(:ticket_of_student_one_course_three)
      lesson = live_studio_lessons(:lesson_three)
      channel = live_studio_channels(:three)
      stream = live_studio_streams(:pull_stream_for_channle_three)

      visit live_studio.play_course_lesson_path(course, lesson)

      page.has_content? channel.name
      page.has_selector?('div#my-video')
    end

  end
end
