require 'test_helper'

module LiveStudio
  class InteractiveCourseTicketTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student_balance)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "student buy a interactive course with account balance" do
      @course = live_studio_interactive_courses(:interactive_course_two_3)
      visit live_studio.new_interactive_course_order_path(@course)
      choose "order_pay_type_account"
      fill_in 'coupon_code', with: '4321'
      click_on '验证'
      assert_difference "@course.reload.buy_tickets_count", 1, "辅导班购买人数没有增加" do
        assert_difference "Payment::Order.count", 1, "订单创建失败" do
          click_on '立即支付'
          fill_in 'payment_password', with: '123123'
          click_on '确认支付'
          sleep(1)
        end
      end
      assert page.has_content?("第2-3个一对一直播")
      order = Payment::Order.last
      assert_equal workstations(:workstation_zhuji).id, order.seller_id, "经销商记录失败"
      assert_equal 360.0, order.amount.to_f, "订单未优惠"
    end
  end
end
