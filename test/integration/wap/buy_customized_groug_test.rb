require 'test_helper'

module Wap
  class BuyCustomizedGroupTest < ActionDispatch::IntegrationTest
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

    # 测试余额购买
    test 'use account balance buy customized group' do
      group = live_studio_groups(:published_group1)
      wap_login(@student, main_app.wap_live_studio_customized_group_path(group))
      click_on "立即报名"
      click_on "新增订单"
      sleep(3)
      choose 'order_pay_type_account'
      assert_difference "::Payment::Order.count", 1, "下单失败" do
        click_on "新增订单"
        sleep(1)
      end
    end

    # 测试使用优惠券购买
    test 'buy customized group with coupon' do
      group = live_studio_groups(:published_group2)
      @cash_account = @student.cash_account!
      coupon = payment_coupons(:coupon_one)
      wap_login(@student, main_app.wap_live_studio_customized_group_path(group, coupon_code: coupon.code))
      click_on "立即报名"
      choose "order_pay_type_account"
      assert_difference "::Payment::Order.count", 1, "下单失败" do
        click_on "新增订单"
        sleep(1)
      end
      assert_equal(-5.0, ::Payment::Order.last.amount - group.current_price, "没有正确使用优惠券")
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
      assert_difference "@cash_account.reload.balance.to_f", -95, "支付失败" do
        assert_difference "@student.reload.live_studio_buy_tickets.count", 1, "辅导班购买失败" do
          click_on '确认支付'
          sleep(1)
        end
      end
      assert_not ::Payment::Order.last.unpaid?, "订单状态没修改"
    end
  end
end
