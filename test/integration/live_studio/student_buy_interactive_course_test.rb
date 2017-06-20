require 'test_helper'

module LiveStudio
  class StudentBuyInteractiveCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student_with_order2)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "student buy off shelve interactive course" do
      course = live_studio_interactive_courses(:interactive_course_three_1)
      visit live_studio.interactive_course_path(course)
      assert page.has_link? '已下架'
      assert page.has_no_link? '立即报名'

      visit live_studio.new_interactive_course_order_path(course)
      assert page.has_content? '该课程已下架!'
    end

    # 学生购买一对一
    test "student buy a interactive course" do
      course = live_studio_interactive_courses(:interactive_course_two_1)
      visit live_studio.new_interactive_course_order_path(course)
      choose "order_pay_type_weixin"
      assert_difference "Payment::Order.count", 1, "订单创建失败" do
        click_on '立即支付'
        sleep 1
      end
    end

    test "student buy a interactive course with coupon" do
      course = live_studio_interactive_courses(:interactive_course_two_2)
      visit live_studio.new_interactive_course_order_path(course)
      choose "order_pay_type_weixin"
      fill_in 'coupon_code', with: '4321'
      click_on '验证'
      assert_difference "Payment::Order.count", 1, "订单创建失败" do
        click_on '立即支付'
        sleep(1)
      end
      order = Payment::Order.last
      assert_equal workstations(:workstation_zhuji).id, order.seller_id, "经销商记录失败"
      assert_equal 630.0, order.amount.to_f, "订单未优惠"
    end
  end
end
