require 'test_helper'
module LiveStudio
  class SchedulesTest < ActionDispatch::IntegrationTest
    def setup
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      Capybara.use_default_driver
    end

    test "student visit schedules view" do
      user = users(:student_one_with_course)
      log_in_as(user)
      click_on '课程表'
      page.find("#wait_lesson_ceil").click
      assert page.has_content?(user.live_studio_lessons.unclosed.first.name)
      page.find("#schedules_ceil").click
      course = user.live_studio_lessons.today.first.course
      page.find(:xpath, "//a[@href='/live_studio/students/#{user.id}/courses/#{course.id}']",match: :first).click
      assert page.has_content?(course.name)
      new_logout_as(user)
    end

    test "teacher visit schedules view" do
      user = users(:teacher_with_chat_account)
      log_in_as(user)
      click_on '课程表'
      page.find("#wait_lesson_ceil").click
      assert page.has_content?(user.live_studio_lessons.unclosed.first.name)
      page.find("#schedules_ceil").click
      course = user.live_studio_lessons.today.first.course
      assert page.has_content?(course.name)
      new_logout_as(user)
    end
  end
end