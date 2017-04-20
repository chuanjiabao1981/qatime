require 'test_helper'

module Wap
  class BuyCourseTest < ActionDispatch::IntegrationTest
    def setup
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student3)
    end

    def teardown
      visit root_path
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    # 测试余额购买辅导班
    test 'use account balance buy a course ' do
      course = live_studio_courses(:billing_course_one)
      wap_login(@student, main_app.wap_live_studio_course_path(course))
      click_on "立即报名"
      click_on "新增订单"
      assert page.has_content?("请选择支付方式"), "不选择支付方式没有提示"
      choose "order_pay_type_account"
      assert_difference "::Payment::Order.count", 1, "下单失败" do
        click_on "新增订单"
        sleep(1)
      end
    end

    # 测试使用优惠券购买
    test 'buy a course with coupon' do
      course = live_studio_courses(:billing_course_two)
      @cash_account = @student.cash_account!
      coupon = payment_coupons(:coupon_one)
      wap_login(@student, main_app.wap_live_studio_course_path(course, coupon_code: coupon.code))
      click_on "立即报名"
      choose "order_pay_type_account"
      assert_difference "::Payment::Order.count", 1, "下单失败" do
        click_on "新增订单"
        sleep(1)
      end
      assert_equal(-10.0, ::Payment::Order.last.amount - course.current_price, "没有正确使用优惠券")
      assert_no_difference "@cash_account.reload.balance.to_f", "错误支付" do
        click_on '确认支付'
      end
      assert page.has_content?("支付密码不能为空"), "不输入支付密码无提示"

      fill_in 'order_payment_password', with: '123124'
      assert_no_difference "@cash_account.reload.balance.to_f", "错误支付" do
        click_on '确认支付'
      end
      assert page.has_content?("支付密码不正确"), "支付密码错误无提示"

      fill_in 'order_payment_password', with: '123123'
      assert_difference "@cash_account.reload.balance.to_f", -490, "支付失败" do
        assert_difference "@student.reload.live_studio_buy_tickets.count", 1, "辅导班购买失败" do
          click_on '确认支付'
          sleep(1)
        end
      end
      assert_not ::Payment::Order.last.unpaid?, "订单状态没修改"
    end

    # 测试微信支付下单
    # 由于微信支付jsapi发起无法模拟后期寻找测试方案
    test 'use weixin buy a course' do
      @course = live_studio_courses(:course_for_refund3)
      @cash_account = @student.cash_account!
      @coupon = payment_coupons(:coupon_one)
      wap_login(@student, main_app.wap_live_studio_course_path(@course, coupon_code: @coupon.code))
      click_on "立即报名"
      choose "order_pay_type_weixin"
      assert_difference "::Payment::Order.count", 1, "下单失败" do
        click_on "新增订单"
        sleep(1)
      end
    end
  end
end
