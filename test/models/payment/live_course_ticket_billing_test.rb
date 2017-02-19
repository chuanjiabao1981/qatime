require 'test_helper'

module Payment
  class LiveCourseTicketBillingTest < ActiveSupport::TestCase
    # 单个学生结账
    test 'test billing a ticket' do
      @workstation_account = workstations(:workstation_one).cash_account
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!
      @sell_account = workstations(:workstation1).cash_account

      lesson = live_studio_lessons(:lesson_one_of_channel_course_one)
      ticket = live_studio_tickets(:ticket_one_of_channel_course_one)
      assert_difference "Payment::LiveCourseTicketBilling.count", 1, "账单创建失败" do
        Payment::LiveCourseTicketBilling.create(target: lesson, from_user: lesson.teacher, ticket: ticket)
      end
      b = Payment::LiveCourseTicketBilling.last
      assert_equal 50.0, b.total_money.to_f, "账单金额不正确"
      assert_equal lesson.course.teacher.id, b.from_user.id, "账单参与者记录错误"
      assert_difference "Payment::LiveCourseTicketBilling.last.billing_items.count", 7, '账单条目数量不正确' do
        assert_difference "@system_account.reload.balance.to_f", -44.18, "系统收入不正确" do
          assert_difference "@workstation_account.reload.balance.to_f", 7.05, "工作站收入不正确" do
            assert_difference "@sell_account.reload.balance.to_f", 4.23, "经销商收入不正确" do
              assert_difference "@teacher_account.reload.balance.to_f", 32.9, "教师收入不正确" do
                b.billing
              end
            end
          end
        end
      end
    end

    # 非渠道购买结账
    test 'test billing a ticket without channel' do
      @workstation_account = workstations(:workstation_one).cash_account
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!

      lesson = live_studio_lessons(:lesson_one_of_channel_course_one)
      ticket = live_studio_tickets(:ticket_three_of_channel_course_one)
      assert_difference "Payment::LiveCourseTicketBilling.count", 1, "账单创建失败" do
        Payment::LiveCourseTicketBilling.create(target: lesson, from_user: lesson.teacher, ticket: ticket)
      end
      b = Payment::LiveCourseTicketBilling.last
      assert_equal 50.0, b.total_money.to_f, "账单金额不正确"
      assert_equal lesson.course.teacher.id, b.from_user.id, "账单参与者记录错误"
      assert_difference "@workstation_account.reload.balance.to_f", 11.28, "工作站收入不正确" do
        b.billing
      end
    end
  end
end
