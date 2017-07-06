require 'test_helper'

module Payment
  class StudentRechargeTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student_recharge)
      new_log_in_as(@student)
      visit get_home_url(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    def notify_params
      {
        notify_time: Time.now.to_s(:db),
        notify_type: 'trade_status_sync',
        notify_id: '1234',
        total_fee: 30,
        trade_status: 'TRADE_FINISHED'
      }
    end

    test 'student recharge list' do
      click_on '我的钱包'
      assert page.has_content?("未支付"), "没有正确显示未支付充值"
      assert page.has_content?("充值成功"), "没有正确显示充值成功"
    end

    test 'student alipay recharge' do
      click_on '我的钱包'
      click_on '充值'
      fill_in :recharge_amount, with: '30'
      choose "recharge_pay_type_alipay"
      assert_difference "Payment::Recharge.count", 1, '支付宝充值下单失败' do
        assert_difference "Payment::AlipayOrder.count", 1, '没有生成支付宝订单' do
          click_on "立即充值"
          sleep(3)
        end
      end

      recharge = @student.payment_recharges.last
      notify = notify_params
      notify[:sign] = Alipay::Sign.generate(notify)
      notify[:sign_type] = 'MD5'
      FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=1234", body: "true")

      assert_difference "@student.cash_account.reload.balance", 30.0, '充值到账金额不正确' do
        post payment.notify_transaction_path(recharge.transaction_no, params: notify)
        assert_response :success, "支付宝支付通知响应失败"
        assert_equal 'success', @response.body, "支付宝支付通知响应格式不正确"
      end
      assert recharge.reload.received?, "支付成功充值失败"
    end

    test 'student weixin recharge' do
      click_on '我的钱包'
      click_on '充值'
      fill_in :recharge_amount, with: '30'
      choose "recharge_pay_type_weixin"
    end
  end
end
