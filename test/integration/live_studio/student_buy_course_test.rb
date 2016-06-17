require 'test_helper'

module LiveStudio
  class StudentBuyCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = ::Student.find(users(:student1).id)
      log_in_as(@student)
    end

    def teardown
      logout_as(@student)
      Capybara.use_default_driver
    end

    test "student search course" do
      course_init = live_studio_courses(:course_init)
      visit live_studio.courses_path
      course_preview = live_studio_courses(:course_preview)
      course_teaching = live_studio_courses(:course_teaching)
      assert(page.has_no_link?("buy-course-#{course_init.id}"), "购买链接错误显示")
      assert(page.has_link?("buy-course-#{course_preview.id}"), "不能正常购买辅导班")
      assert(page.has_link?("buy-course-#{course_teaching.id}"), "不能正常购买辅导班")
    end

    test "student buy course" do
      visit live_studio.courses_path
      course_preview = live_studio_courses(:course_preview)
      assert_difference '@student.orders.count', 1, "辅导班下单失败" do
        click_on("buy-course-#{course_preview.id}")
        choose("order_pay_type_0")
        click_on("新增订单")
      end
    end

    test "student pay order" do
    end
  end
end
