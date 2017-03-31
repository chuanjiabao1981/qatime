require 'test_helper'

module LiveServiceTest
  class InteractiveCourseBillingDirectorTest < ActiveSupport::TestCase
    # 单价 70
    # 服务费 6
    # 教师分成 60% 64 * 0.6 = 38.4
    # 发行分成 5% 64 * 0.05 = 3.2
    # 销售非诚 25% 64 * 0.25 = 16
    # 平台分成 10% 64 * 0.1 = 6.4
    test 'test billing a interactive course' do
      @publish_account = workstations(:workstation_one).cash_account
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!

      lesson = live_studio_interactive_lessons(:interactive_course_three_2_lesson_1)
      director = BusinessService::InteractiveCourseBillingDirector.new(lesson)
      assert_difference "Payment::BillingItem.count", 5, '账单条目数量不正确' do
        assert_difference "@system_account.reload.balance.to_f", -57.6, "系统收入不正确" do
          assert_difference "@publish_account.reload.balance.to_f", 19.2, "发行商收入不正确" do
            assert_difference "@teacher_account.reload.balance.to_f", 38.4, "教师收入不正确" do
              director.billing_lesson
            end
          end
        end
      end

      assert lesson.reload.completed?, "结账状态不正确"
    end
  end
end
