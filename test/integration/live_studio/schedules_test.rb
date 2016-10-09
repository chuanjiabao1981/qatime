require 'test_helper'
module LiveStudio
  class SchedulesTest < ActionDispatch::IntegrationTest
    def setup
      # @routes = Engine.routes
      @admin = users(:admin)
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      Capybara.use_default_driver
    end

    test "student visit schedules view" do
      user = users(:student_one_with_course)
      new_log_in_as(user)
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

    test "admin visit schedules" do
      today = Date.today
      student = users(:student_one_with_course)
      teacher = users(:teacher_with_chat_account)
      log_in_as(@admin)
      visit student_path(student)
      click_on '课程表'
      assert today.to_s == find("#calendar").find(".active")[:rel], "没有默认选中今日"
      find(".cell-#{today.month}-1").click
      find(".cell-#{today.month}-#{today.day}").click
      sleep(3)
      assert all(".schedules-tb").size == 2, '数据没有出现'
      assert page.has_content?("课程日历")
      assert page.has_content?("未上课")
      assert page.has_content?("已上课")
      visit teacher_path(teacher)
      click_on '课程表'
      assert today.to_s == find("#calendar").find(".active")[:rel], "没有默认选中今日"
      find(".cell-#{today.month}-1").click
      find(".cell-#{today.month}-#{today.day}").click
      sleep(3)
      assert all(".schedules-tb").size == 1, '数据没有出现'
      assert page.has_content?("课程日历")
      assert page.has_content?("未上课")
      assert page.has_content?("已上课")
      new_logout_as(@admin)
    end
  end
end