require 'test_helper'

module LiveStudio
  class StudentBuyCustomizedGroupTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student_with_order2)

      account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: 'xxxxx', token: 'thisisatoken' } }.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "student buy off shelve customized_group" do
      customized_group = live_studio_groups(:completed_group1)
      visit live_studio.customized_group_path(customized_group)
      assert page.has_link? '已下架'
      assert page.has_no_link? '立即报名'

      visit live_studio.new_customized_group_order_path(customized_group)
      assert page.has_content? '该课程已下架!'
    end

    test "student buy customized_group" do
      customized_group = live_studio_groups(:published_group1)
      visit live_studio.customized_group_path(customized_group)
      click_link '立即报名'
      choose "order_pay_type_weixin"
      assert_difference "Payment::Order.count", 1, "订单创建失败" do
        click_on '立即支付'
        sleep 1
      end
    end

    # 余额支付购买辅导班
    test "buy course with account balance" do
      new_logout_as(@student)
      @student_balance = users(:student_balance)
      new_log_in_as(@student_balance)
      customized_group = live_studio_groups(:published_group1)
      visit live_studio.customized_group_path(customized_group)
      click_link '立即报名'
      choose "order_pay_type_account"

      assert_difference "@student_balance.cash_account!.reload.balance.to_f", -100, "没有正确扣除余额" do
        assert_difference "@student_balance.cash_account!.reload.total_expenditure.to_f", 100, "总消费计算不正确" do
          assert_difference "Payment::ConsumptionRecord.count", 1, "没有生成消费记录" do
            assert_difference '@student_balance.reload.orders.count', 1, "辅导班下单失败" do
              assert_difference 'customized_group.reload.buy_tickets_count', 1, "购买人数没有增加" do
                click_on '立即支付'
                fill_in :payment_password, with: '123123'
                click_on '确认支付'
                sleep 1
              end
            end
          end
        end
      end
      new_logout_as(@student_balance)
      new_log_in_as(@student)
    end

    # 使用优惠码购买辅导班,并验证
    test "student use coupon buy course with account balance" do
      new_logout_as(@student)
      @student_balance = users(:student_balance)
      @coupon_one = payment_coupons(:coupon_one)
      new_log_in_as(@student_balance)
      customized_group = live_studio_groups(:published_group2)
      visit live_studio.customized_group_path(customized_group)

      click_link '立即报名'

      fill_in :coupon_code, with: @coupon_one.code
      click_on '验证'

      assert_difference "@student_balance.cash_account!.reload.balance.to_f", -95, "没有正确扣除优惠余额" do
        assert_difference "@student_balance.cash_account!.reload.total_expenditure.to_f", 95, "优惠总消费计算不正确" do
          assert_difference "Payment::ConsumptionRecord.count", 1, "没有生成消费记录" do
            assert_difference '@student_balance.reload.orders.count', 1, "辅导班下单失败" do
              choose "order_pay_type_account"
              click_on '立即支付'
              fill_in :payment_password, with: '123123'
              click_on '确认支付'
              sleep 2
            end
          end
        end
      end
      new_logout_as(@student_balance)
      new_log_in_as(@student)
    end

  end
end
