require 'test_helper'

module LiveStudio
  class StudentBuyCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = ::Student.find(users(:student_with_order).id)
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
        choose("order_pay_type_1")
        click_on("新增订单")
      end
    end

    test "student pay order" do
      @order = payment_orders(:order_one)
      visit payment.user_order_path(@order.order_no)
      assert has_selector?('img#wechat_qrcode')
      assert_difference "CashAdmin.current_cash", @order.total_money.to_f, "订单支付完成系统收入不正确" do
        @order.pay_and_ship!
      end
    end

    test "student taste and buy course" do
      course = live_studio_courses(:course_with_lessons)
      visit live_studio.courses_path
      assert_difference "course.reload.taste_tickets.count", 1, "不能正确生成试听证" do
        assert_difference "@student.live_studio_courses.count", 1, "不能正确试听辅导班" do
          click_on("taste-course-#{course.id}")
          assert has_no_selector?("#taste-course-#{course.id}")
        end
      end
      visit live_studio.courses_path
    end

    test "student buy tasting course" do
      course = live_studio_courses(:tasting_course)
      visit live_studio.courses_path
      assert_difference "@student.reload.orders.count", 1, "正在试听的辅导班下单失败" do
        click_on("buy-course-#{course.id}")
        choose("order_pay_type_1")
        click_on("新增订单")
      end
    end
  end
end
