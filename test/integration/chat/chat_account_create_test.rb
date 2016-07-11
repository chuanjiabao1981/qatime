require 'test_helper'

module LiveStudio
  class ChatAccountCreateTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:no_chat_account_student)
      log_in_as(@student)
    end

    def teardown
      logout_as(@student)
      Capybara.use_default_driver
    end

    test "student buy course without account" do
      course = live_studio_courses(:course_with_lessons)
      visit live_studio.courses_index_path(student_id: @student)

      assert_nil @student.chat_account

      assert_difference "course.reload.taste_tickets.count", 1, "不能正确生成试听证" do
        assert_difference "@student.live_studio_courses.count", 1, "不能正确试听辅导班" do
          click_on("taste-course-#{course.id}")
          p @student.chat_account
          assert_not_nil @student.chat_account
          assert has_no_selector?("#taste-course-#{course.id}")
        end
      end
    end

  end
end
