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
      sleep(1)
      assert page.has_content?(user.live_studio_lessons.unclosed.first.name)
      assert_equal page.all('.status-personal').size, user.live_studio_interactive_lessons.unclosed.count, '未上课一对一数量不对'

      click_on '进入', match: :first
      assert page.has_content? '一对一课程需要使用客户端才能进入，请安装最新版本'
      find("span[aria-label='Close']").click

      page.find("#close_lessons_ceil").click
      sleep(1)
      assert page.has_content? '已结束'
      assert_equal page.all('.status-personal').size, user.live_studio_interactive_lessons.already_closed.count, '未上课一对一数量不对'

      page.find("#schedules_ceil").click
      sleep(1)
      interactive_lesson = user.live_studio_interactive_lessons.today.first
      assert page.has_content?(interactive_lesson.name)
      course = user.live_studio_lessons.today.first.course
      page.find(:xpath, "//a[@href='/live_studio/courses/#{course.id}/play']", match: :first).click
      assert page.has_content?(course.name)
      new_logout_as(user)
    end

    test "teacher visit schedules view" do
      user = users(:teacher_with_chat_account)
      log_in_as(user)
      click_on '课程表'
      page.find("#wait_lesson_ceil").click
      sleep(1)
      assert page.has_content?(user.live_studio_lessons.unclosed.first.name)
      assert_equal page.all('.status-personal').size, 2, '未上课一对一数量不对'
      assert page.has_content? '直播课'
      assert page.has_content? '学生人数'

      page.find("#close_lessons_ceil").click
      sleep(1)
      assert page.has_content? '已直播'
      assert page.has_content? '已结束'

      page.find("#schedules_ceil").click
      sleep(1)
      lesson = user.live_studio_lessons.today.first
      interactive_lesson = user.live_studio_interactive_lessons.today.first
      assert page.has_content?(lesson.name)
      assert page.has_content?(interactive_lesson.name)
      new_logout_as(user)
    end

    test "admin visit schedules" do
      today = Date.today
      student = users(:student_one_with_course)
      teacher = users(:teacher_with_chat_account)
      log_in_as(@admin)
      visit student_path(student)
      click_on '课程表'
      assert today.to_date == find("#calendar").find(".active")[:rel].to_date, "没有默认选中今日"
      find(".cell-#{today.month}-1").click
      find(".cell-#{today.month}-#{today.day}").click
      sleep(3)
      assert_equal 3, all("#calendar_data li").size, '数据没有出现'
      assert page.has_content?("全部课程")
      assert page.has_content?("未上课")
      assert page.has_content?("已上课")
      visit teacher_path(teacher)
      click_on '课程表'
      assert today.to_s == find("#calendar").find(".active")[:rel], "没有默认选中今日"
      find(".cell-#{today.month}-1").click
      find(".cell-#{today.month}-#{today.day}").click
      sleep(3)
      assert_equal 2, all("#calendar_data li").size, '数据没有出现'
      assert page.has_content?("全部课程")
      assert page.has_content?("未上课")
      assert page.has_content?("已上课")
      new_logout_as(@admin)
    end
  end
end
