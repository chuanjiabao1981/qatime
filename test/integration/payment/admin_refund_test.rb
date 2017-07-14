require 'test_helper'

module Payment
  class AdminRefundTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @admin = users(:admin)
      new_log2_in_as(@admin)
      visit get_home_url(@admin)
    end

    def teardown
      new_logout_as(@admin)
      Capybara.use_default_driver
    end

    test 'admin pass audit refund test' do
      click_link '退款审核'

      @refund = payment_transactions(:interactive_course_refund_1)
      @teacher1 = @refund.product.teachers.first
      @teacher2 = @refund.product.teachers.second

      assert_difference "@teacher1.reload.notifications.count", 1, "退款没有通知老师1" do
        assert_difference "@teacher2.reload.notifications.count", 1, "退款没有通知老师2" do
          accept_prompt(with: '确认') do
            find(:xpath, "//a[@href=\"#{pass_admins_refund_path(@refund)}\"]").click
          end
          sleep(1)
        end
      end
      assert @refund.product.reload.refunded?, "一对一退款以后没有正常结束"
    end

    test 'admin pass refund test' do
      # assert refund status success
      # assert buy_tickets status refunded
      # assert buy_ticket status refunded
      # assert order status refunded
      # assert cash_admin.cash_account change balance
      # assert admin operating record
      # assert refund create
      # assert course can sell to student
      click_on '退款审核'
      ra = Payment::Refund.init.first
      user_account = ra.user.cash_account
      assert_difference 'user_account.balance', +ra.amount, '未退款至学生账户' do
        assert_difference 'CashAdmin.current!.cash_account.balance', -ra.amount, '管理员资金未变动' do
          accept_prompt(with: "确认") do
            find(:xpath, "//a[@href='#{pass_admins_refund_path(ra)}']").click
          end
          sleep 3
        end
        user_account.reload
      end
      click_on '已审核'
      assert has_content?('正在退款')
      assert ra.status, 'refunded'

      assert_equal ra.user.live_studio_buy_tickets.unscope(where: :status).where(product: ra.product).first.status, 'refunded'
      assert_equal ra.order.status, 'refunded'
      assert_equal ActionRecord.last.actionable, ra, '管理员操作记录没有创建'
      assert_not ra.product.bought_by?(ra.user), '无法再次购买'
      assert_equal Notification.last.notificationable, ra.order, '没有审核创建通知'
    end

    test 'admin unpass refund test' do
      # assert buy ticket status active
      # assert order status complete
      # assert admin operating record
      # 退款状态
      click_on '退款审核'
      ra = Payment::Refund.init.last
      accept_prompt(with: "确认") do
        find(:xpath, "//a[@href='#{unpass_admins_refund_path(ra)}']").click
      end
      sleep 2
      assert_equal ra.user.live_studio_buy_tickets.where(product: ra.product).first.status, 'active'
      assert_equal ra.order.status, 'paid', '订单状态未退回付款状态(可重新提交退款申请)'
      assert_equal ActionRecord.last.actionable, ra, '管理员操作记录没有创建'
      assert_equal Notification.last.notificationable, ra.order, '没有审核创建通知'
    end
  end
end
