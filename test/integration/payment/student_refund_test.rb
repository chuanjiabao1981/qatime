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
      visit get_home_url(@student)
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
