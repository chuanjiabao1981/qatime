require 'test_helper'

module Payment
  class LiveCourseChannelBillingTest < ActiveSupport::TestCase
    test 'test total money calculate' do
      lesson = live_studio_lessons(:lesson_one_of_course_for_billing_one)
      assert_equal 250.0, Payment::LiveCourseBilling.new(target: lesson).calculate.total_money.to_f, "结账金额不正确"
    end

    # 基础服务费计算
    test 'test base fee calculate' do
      lesson = live_studio_lessons(:lesson_one_of_course_for_billing_one)
      billing = Payment::LiveCourseBilling.new(target: lesson).calculate
      assert_equal 15.0, billing.base_fee.to_f, "基础服务费计算错误"
    end

    # 教师收入计算
    test 'test teacher money calculate' do
      lesson = live_studio_lessons(:lesson_one_of_course_for_billing_one)
      billing = Payment::LiveCourseBilling.new(target: lesson).calculate
      assert_equal 188.0, billing.teacher_money.to_f, "教师收入计算错误"
    end

    # 总分成计算
    test 'test total percent money calculate' do
      lesson = live_studio_lessons(:lesson_one_of_course_for_billing_one)
      billing = Payment::LiveCourseBilling.new(target: lesson).calculate
      assert_equal 47.0, billing.percent_money.to_f, "分成金额计算错误"
    end

    # 工作站收入计算
    test 'test workstation percent money calculate' do
      lesson = live_studio_lessons(:lesson_one_of_course_for_billing_one)
      billing = Payment::LiveCourseBilling.new(target: lesson).calculate
      assert_equal 37.6, billing.workstation_percent_money.to_f, "工作站收入计算计算错误"
    end

    # 系统分成收入计算
    test 'test system percent money calculate' do
      lesson = live_studio_lessons(:lesson_one_of_course_for_billing_one)
      billing = Payment::LiveCourseBilling.new(target: lesson).calculate
      assert_equal 9.4, billing.system_percent_money.to_f, "系统分成收入计算错误"
    end

    # 结账测试
    test 'test billing a lesson' do
      @workstation = workstations(:workstation1)
      @teacher = users(:teacher_for_billing)
      @lesson = live_studio_lessons(:lesson_one_of_course_for_billing_one)
      assert_difference "@teacher.cash_account!.reload.balance.to_f", 188.0, "教师收入不正确" do
        assert_difference "@workstation.cash_account!.reload.balance.to_f", 37.6, "工作站收入不正确" do
          assert_difference "CashAdmin.current!.cash_account!.balance.to_f", -225.6, "系统资金变动错误" do
            assert_difference "Payment::BillingItem.count", 6, "账单条目不正确" do
              Payment::LiveCourseBilling.new(target: @lesson).calculate.billing
            end
          end
        end
      end
    end

    # 邀请辅导班结账测试test 'test billing a lesson' do
    test 'test billing a  invite lesson' do
      @workstation = workstations(:workstation1)
      @teacher = users(:teacher_for_billing)
      @lesson = live_studio_lessons(:lesson_one_of_course_for_billing_two)
      assert_difference "@teacher.cash_account!.reload.balance.to_f", 100.8, "教师收入不正确" do
        assert_difference "@workstation.cash_account!.reload.balance.to_f", 34.56, "工作站收入不正确" do
          assert_difference "CashAdmin.current!.cash_account!.balance.to_f", -135.36, "系统资金变动错误" do
            Payment::LiveCourseBilling.new(target: @lesson).calculate.billing
          end
        end
      end
    end
  end
end
