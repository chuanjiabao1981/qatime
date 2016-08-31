require 'test_helper'

module LiveStudio
  class StudentBuyCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = ::Student.find(users(:student_with_order2).id)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "student search course" do
      course_init = live_studio_courses(:course_init)
      visit live_studio.courses_index_path(student_id: @student)
      course_preview_two = live_studio_courses(:course_preview_two)
      course_teaching = live_studio_courses(:course_teaching)
      assert(page.has_no_link?("buy-course-#{course_init.id}"), "购买链接错误显示")
      assert(page.has_link?("buy-course-#{course_preview_two.id}"), "不能正常购买辅导班")
      assert(page.has_link?("buy-course-#{course_teaching.id}"), "不能正常购买辅导班")
    end

    test "student buy course" do
      visit live_studio.courses_index_path(student_id: @student)
      course_preview = live_studio_courses(:course_preview)
      assert_difference '@student.orders.count', 1, "辅导班下单失败" do
        click_on("buy-course-#{course_preview.id}")
        click_link '微信支付'
        click_on '立即支付'
        page.has_content? "提示：如支付遇到问题，请拨打电话 010-58442007"
      end
    end

    test "student pay order" do
      @order = payment_orders(:order5)
      visit payment.pay_user_order_path(@student,@order.order_no)
      assert has_selector?('img#wechat_qrcode')
      assert_difference "CashAdmin.current_cash", @order.total_money.to_f, "订单支付完成系统收入不正确" do
        @order.pay_and_ship!
      end
    end

    test "student taste and buy course" do
      course = live_studio_courses(:course_with_lessons)
      visit live_studio.courses_index_path(student_id: @student)
      count = @student.live_studio_courses.count
      taste_count = course.reload.taste_tickets.count
      click_on("taste-course-#{course.id}")
      sleep 2
      assert_equal @student.reload.live_studio_courses.count, count+1, "不能正确试听辅导班"
      assert_equal course.reload.taste_tickets.count, taste_count+1, "不能正确生成试听证"
    end

    test "student buy tasting course" do
      course = live_studio_courses(:tasting_course)
      visit live_studio.courses_index_path(student_id: @student)
      assert_difference "@student.reload.orders.count", 1, "正在试听的辅导班下单失败" do
        #visit live_studio.new_course_order_path(course)
        click_on("buy-course-#{course.id}")
        click_link '微信支付'
        click_on '立即支付'
      end
    end
  end
end
