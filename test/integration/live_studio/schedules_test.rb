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
      visit get_home_url(user)
      click_on '课程表'
      page.find("#wait_lesson_ceil").click
      sleep(1)

      week_items = LiveService::ScheduleService.schedule_for(user).week
      wait_lessons = week_items.select { |item| item.target.unclosed? }.sort_by { |item| item.target.start_at }
      ticket_item = wait_lessons.first

      assert page.has_link?(ticket_item.target.name)
      assert_equal wait_lessons.select{|x| x.target.is_a?(::LiveStudio::InteractiveLesson)}.count, page.all('.status-personal').size, '未上课一对一数量不对'
      find(:xpath,"//a[@data-target='#dawnloadModal']", match: :first).click
      assert page.has_content? '一对一课程需要使用客户端学习，正在尝试打开PC客户端（如未打开请安装最新版本'
      find("span[aria-label='Close']").click

      page.find("#schedules_ceil").click
      sleep(1)

      month_items = LiveService::ScheduleService.schedule_for(user).month
      today_items = month_items.select { |item| item.target.class_date.to_s == Date.today.to_s }
      assert page.has_link?(today_items.first.target.name)
      new_logout_as(user)
    end

    test "teacher visit schedules view" do
      user = users(:teacher_with_chat_account)
      log_in_as(user)
      visit get_home_url(user)
      click_on '课程表'
      page.find("#wait_lesson_ceil").click
      sleep(1)
      week_items = LiveService::ScheduleService.schedule_for(user).week
      wait_lessons = week_items.select(&:unclosed?).sort_by(&:start_at)
      assert page.has_link?(week_items.first.name)
      assert_equal wait_lessons.select{|x| x.is_a?(::LiveStudio::InteractiveLesson)}.count, page.all('.status-personal').size, '未上课一对一数量不对'
      assert page.has_content? '直播课'
      assert page.has_content? '学生人数'

      page.find("#schedules_ceil").click
      sleep(1)
      month_items = LiveService::ScheduleService.schedule_for(user).month
      today_items = month_items.select { |item| item.class_date.to_s == Date.today.to_s }
      assert page.has_link?(today_items.first.name)
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
