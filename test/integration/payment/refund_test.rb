require 'test_helper'

module Payment
  class RefundTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

    end

    def teardown
      Capybara.use_default_driver
    end

    test 'student apply refund order test' do
      # assert refund_apply create and status init
      # assert buy_ticket refunding
      # assert order refunding
      # assert course cant for_sell for student
      # assert course cant study for student
      @student = users(:student_order_for_refund)
      new_log_in_as(@student)
      click_on '我的订单'
      click_link '申请退款', match: :first
      fill_in 'reason', with: 'test refund'
      click_on '提交'
      assert has_content?('退款申请已创建'), '退款申请未创建成功'

      assert_equal Payment::RefundApply.last.user, @student, '没有创建退款申请'
      assert_equal @student.live_studio_buy_tickets.first.status, 'refunding', '票据状态未更新'
      assert_equal @student.orders.last.status, 'refunding', '订单状态未更新'
      visit live_studio.course_path(@student.orders.last.product)
      assert !has_content?('立即报名'), '不能购买辅导班'
      click_on '开始学习'
      assert has_content?('辅导班无授权!'), '不能开始学习'
      new_logout_as(@student)
    end

    test 'admin pass refund_apply test' do
      # assert refund_apply status success
      # assert buy_tickets status refunded
      # assert buy_ticket status refunded
      # assert order status refunded
      # assert cash_admin.cash_account change balance
      # assert admin operating record
      # assert refund create
      # assert course can sell to student
      admin_balance = CashAdmin.current!.cash_account!.available_balance
      @admin = users(:admin)
      new_log_in_as(@admin)
      click_on '退款审核'
      accept_prompt(with: "确认") do
        click_link '通过', match: :first
      end
      click_on '已审核'
      assert has_content?('已退款')
      ra = Payment::RefundApply.refunded.first
      assert ra.status, 'refunded'
      assert_equal ra.user.live_studio_buy_tickets.where(course: ra.product).first.status, 'refunded'
      assert_equal ra.order.status, 'refunded'
      assert_equal CashAdmin.current!.cash_account.available_balance, admin_balance - ra.amount, '管理员资金未变动'
      assert_equal ActionRecord.last.actionable, ra, '管理员操作记录没有创建'
      assert_equal Payment::Refund.last, ra.refunds.last, '退款订单未创建'
      assert !ra.product.bought_by?(ra.user), '无法再次购买'
      new_logout_as(@admin)
    end

    test 'admin unpass refund_apply test' do
      # assert buy ticket status active
      # assert order status complete
      # assert admin operating record
      @admin = users(:admin)
      new_log_in_as(@admin)
      click_on '退款审核'
      accept_prompt(with: "确认") do
        click_link '驳回', match: :first
      end
      sleep 2
      ra = Payment::RefundApply.ignored.last
      assert_equal ra.user.live_studio_buy_tickets.where(course: ra.product).first.status, 'active'
      assert_equal ra.order.status, 'completed', '订单状态未恢复'
      assert_equal ActionRecord.last.actionable, ra, '管理员操作记录没有创建'
      new_logout_as(@admin)
    end
  end
end
