require 'test_helper'

module Payment
  class LiveCourseTicketBillingTest < ActiveSupport::TestCase
    # 单个学生结账
    # 视频时长 30分钟
    # 教师分成 50%
    # 经销商分成 30%
    # 发行商分成 10%
    # 系统分成 10%
    test 'test billing a ticket' do
      @publish_account = workstations(:workstation_one).cash_account
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!
      @sell_account = workstations(:workstation1).cash_account

      lesson = live_studio_lessons(:lesson_one_of_billing_course_one)
      ticket = live_studio_tickets(:ticket_one_of_billing_course_one)
      assert_difference "Payment::LiveCourseTicketBilling.count", 1, "账单创建失败" do
        Payment::LiveCourseTicketBilling.create(target: lesson, from_user: lesson.teacher, ticket: ticket)
      end
      b = Payment::LiveCourseTicketBilling.last
      assert_equal 50.0, b.total_money.to_f, "账单金额不正确"
      assert_equal lesson.course.teacher.id, b.from_user.id, "账单参与者记录错误"
      assert_difference "Payment::LiveCourseTicketBilling.last.billing_items.count", 6, '账单条目数量不正确' do
        assert_difference "@system_account.reload.balance.to_f", -42.3, "系统收入不正确" do
          assert_difference "@publish_account.reload.balance.to_f", 4.7, "发行商收入不正确" do
            assert_difference "@sell_account.reload.balance.to_f", 14.1, "经销商收入不正确" do
              assert_difference "@teacher_account.reload.balance.to_f", 23.5, "教师收入不正确" do
                b.billing
              end
            end
          end
        end
      end
    end

    # 非渠道购买结账
    test 'test billing a ticket without channel' do
      @publish_account = workstations(:workstation_one).cash_account
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!
      @sell_account = Workstation.default.cash_account

      lesson = live_studio_lessons(:lesson_one_of_billing_course_one)
      ticket = live_studio_tickets(:ticket_three_of_billing_course_one)
      assert_difference "Payment::LiveCourseTicketBilling.count", 1, "账单创建失败" do
        Payment::LiveCourseTicketBilling.create(target: lesson, from_user: lesson.teacher, ticket: ticket)
      end
      b = Payment::LiveCourseTicketBilling.last
      assert_equal 50.0, b.total_money.to_f, "账单金额不正确"
      assert_equal lesson.course.teacher.id, b.from_user.id, "账单参与者记录错误"
      assert_difference "Payment::LiveCourseTicketBilling.last.billing_items.count", 6, '账单条目数量不正确' do
        assert_difference "@system_account.reload.balance.to_f", -42.3, "系统收入不正确" do
          assert_difference "@publish_account.reload.balance.to_f", 4.7, "发行商收入不正确" do
            assert_difference "@sell_account.reload.balance.to_f", 14.1, "经销商收入不正确" do
              assert_difference "@teacher_account.reload.balance.to_f", 23.5, "教师收入不正确" do
                b.billing
              end
            end
          end
        end
      end
    end

    # 测试错误分成比例结账
    test 'test billing a invalid lesson' do
      lesson = live_studio_lessons(:lesson_of_billing_fail_course_one)
      ticket = live_studio_tickets(:ticket_of_billing_fail_course_one)
      assert_difference "Payment::LiveCourseTicketBilling.count", 1, "账单创建失败" do
        Payment::LiveCourseTicketBilling.create(target: lesson, from_user: lesson.teacher, ticket: ticket)
      end
      b = Payment::LiveCourseTicketBilling.last
      assert_equal 50.0, b.total_money.to_f, "账单金额不正确"
      assert_equal lesson.course.teacher.id, b.from_user.id, "账单参与者记录错误"
      assert_raises(Payment::TotalPercentInvalid) do
        b.billing
      end
    end

    # 账单计算测试
    test 'test billing money' do
      lesson = live_studio_lessons(:lesson_one_of_billing_course_one)
      ticket = live_studio_tickets(:ticket_three_of_billing_course_one)
      billing = Payment::LiveCourseTicketBilling.new(target: lesson, from_user: lesson.teacher, ticket: ticket)
      billing.calculate
      assert_equal 3, billing.base_fee, "服务费计算错误"
      assert_equal 47, billing.percent_money, "分成金额计算不正确"
      assert_equal 23.5, billing.teacher_money, "教师收入计算不正确"
      assert_equal 14.1, billing.sell_money, "经销商收入计算不正确"
      assert_equal 4.7, billing.publish_money, "发行商下收入计算不正确"
      assert_equal 4.7, billing.system_money, "系统分成收入计算不正确"
    end
  end
end
