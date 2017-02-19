require 'test_helper'

module Payment
  class LiveCourseChannelBillingTest < ActiveSupport::TestCase
    # 单个学生结账
    test 'test billing a lesson with multiple channel ' do
      @workstation_account = workstations(:workstation_one).cash_account # 发行商
      @sell1_account = workstations(:workstation1).cash_account # 渠道商1
      @sell2_account = workstations(:workstation_zhuji).cash_account # 渠道商2
      @sell3_account = workstations(:workstation_hd).cash_account # 渠道商3
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!

      lesson = live_studio_lessons(:lesson_one_of_channel_course_two)
      assert_difference "Payment::LiveCourseChannelBilling.count", 1, "账单创建失败" do
        Payment::LiveCourseChannelBilling.create(target: lesson, from_user: lesson.teacher)
      end
      b = Payment::LiveCourseChannelBilling.last
      assert_equal 380.0, b.total_money.to_f, "账单金额不正确"
      assert_equal lesson.course.teacher.id, b.from_user.id, "账单参与者记录错误"
      assert_difference "Payment::LiveCourseChannelBilling.last.sub_billings.count", 7, '结账数量不正确' do
        assert_difference "@system_account.reload.balance.to_f", -297.6, "系统收入不正确" do
          assert_difference "@workstation_account.reload.balance.to_f", 28.4, "工作站收入不正确" do
            assert_difference "@sell1_account.reload.balance.to_f", 7.2, "经销商1收入不正确" do
              assert_difference "@sell2_account.reload.balance.to_f", 8.0, "经销商2收入不正确" do
                assert_difference "@sell3_account.reload.balance.to_f", 6.0, "经销商3收入不正确" do
                  assert_difference "@teacher_account.reload.balance.to_f", 248.0, "教师收入不正确" do
                    b.billing
                  end
                end
              end
            end
          end
        end
      end
      assert lesson.reload.completed?, "课程结账状态不正确"
    end
  end
end
