require 'test_helper'

module Payment
  class StudentRefundTest < ActionDispatch::IntegrationTest
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
      # assert refund create and status init
      # assert buy_ticket refunding
      # assert order refunding
      # assert course cant for_sell for student
      # assert course cant study for student
      @student = users(:student_order_for_refund)
      order = payment_transactions(:order_for_refund)
      new_log_in_as(@student)
      click_on '我的订单'
      click_on '已付款'
      find(:xpath, "//a[@href='#{payment.refund_user_order_path(@student, order.transaction_no)}']").click
      choose :teacher_bad
      click_on '提交'
      order.reload
      assert has_content?('退款已创建'), '退款申请未创建成功'
      assert_equal Payment::Refund.last.user, @student, '没有创建退款申请'
      assert_equal @student.live_studio_buy_tickets.first.status, 'refunding', '票据状态未更新'
      assert_equal order.status, 'refunding', '订单状态未更新'
      visit live_studio.course_path(order.product)
      assert has_content?('立即报名'), '不能购买辅导班'
      new_logout_as(@student)
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
      @admin = users(:admin)
      new_log_in_as(@admin)
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
      new_logout_as(@admin)
    end

    test 'admin unpass refund test' do
      # assert buy ticket status active
      # assert order status complete
      # assert admin operating record
      # 退款状态
      @admin = users(:admin)
      new_log_in_as(@admin)
      click_on '退款审核'
      ra = Payment::Refund.init.last
      accept_prompt(with: "确认") do
        find(:xpath, "//a[@href='#{unpass_admins_refund_path(ra)}']").click
      end
      sleep 2
      assert_equal ra.user.live_studio_buy_tickets.where(product: ra.product).first.status, 'active'
      assert_equal ra.order.status, 'completed', '订单状态未恢复'
      assert_equal ActionRecord.last.actionable, ra, '管理员操作记录没有创建'
      assert_equal Notification.last.notificationable, ra.order, '没有审核创建通知'
      new_logout_as(@admin)
    end

    test 'billed lesson refund test' do
      # 测试辅导班已结算的费用是否扣除
      buy_ticket = live_studio_tickets(:ticket_for_refund3)
      order = payment_transactions(:order_for_refund3)
      new_log_in_as(order.user)
      visit payment.refund_user_order_path(order.user, order.transaction_no)
      choose :teacher_bad
      click_on '提交'
      ra = Payment::Refund.find_by(order: order)
      assert_equal ra.amount, buy_ticket.lesson_price, '退款金额未扣除已结算课程'
      new_logout_as(order.user)
    end

    test 'remote order status test' do
      remote_order = payment_remote_orders(:weixin_refund_remote_order)
      refund = payment_transactions(:weixin_refund)
      refund.allow!(users(:admin))
      remote_order.reload
      assert_equal remote_order.status, 'refunded', '原微信支付订单状态没有改变'
    end

    test 'refunded lesson billing test' do
      course = live_studio_courses(:course_for_refund3)
      refunded_ticket = live_studio_tickets(:refund_ticket)

      BusinessService::CourseBillingDirector.new(course.lessons.finished.first).billing_lesson
      assert_not_includes course.buy_tickets, refunded_ticket
      assert_equal Billing.last.total_money, course.lesson_price, '课程结算只有一节课的费用200元'
    end
  end
end
