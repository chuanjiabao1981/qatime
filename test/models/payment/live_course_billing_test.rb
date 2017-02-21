require 'test_helper'

module Payment
  class LiveCourseBillingTest < ActiveSupport::TestCase
    # 测试计算金额
    test 'test calculate' do
      lesson = live_studio_lessons(:lesson_one_of_course_for_billing_one)
      billing = Payment::LiveCourseBilling.new(target: lesson)
      billing.calculate
      assert_equal 250.0, billing.total_money.to_f, "结账金额不正确"
    end

    # 测试结账
    # 视频时长 100分钟
    # @sell1_account 3个学生
    # @sell2_account 2个学生
    # @sell3_account 1个学生
    # @sell4_account 1个学生(直接购买)
    # 教师分成 45%
    # 销售分成 35%
    # 发行分成 15%
    # 系统分成 5%
    # 价格 60
    test 'test billing' do
      @publish_account = workstations(:workstation_one).cash_account # 发行商
      @sell1_account = workstations(:workstation1).cash_account # 渠道商1
      @sell2_account = workstations(:workstation_zhuji).cash_account # 渠道商2
      @sell3_account = workstations(:workstation_hd).cash_account # 渠道商3
      @sell4_account = Workstation.default.cash_account
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!

      lesson = live_studio_lessons(:lesson_one_of_billing_course_two)
      assert_difference "Payment::LiveCourseBilling.count", 1, "账单创建失败" do
        Payment::LiveCourseBilling.create(target: lesson, from_user: lesson.teacher)
      end
      b = Payment::LiveCourseBilling.last
      assert_equal 420.0, b.total_money.to_f, "账单金额不正确"
      assert_equal lesson.course.teacher.id, b.from_user.id, "账单参与者记录错误"
      assert_difference "Payment::LiveCourseBilling.last.sub_billings.count", 7, '结账数量不正确' do
        assert_difference "@system_account.reload.balance.to_f", -332.5, "系统收入不正确" do
          assert_difference "@publish_account.reload.balance.to_f", 52.5, "发行商收入不正确" do
            assert_difference "@sell1_account.reload.balance.to_f", 52.5, "经销商1收入不正确" do
              assert_difference "@sell2_account.reload.balance.to_f", 35.0, "经销商2收入不正确" do
                assert_difference "@sell3_account.reload.balance.to_f", 17.5, "经销商3收入不正确" do
                  assert_difference "@sell4_account.reload.balance.to_f", 17.5, "默认工作站收入不正确" do
                    assert_difference "@teacher_account.reload.balance.to_f", 157.5, "教师收入不正确" do
                      b.billing
                    end
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
