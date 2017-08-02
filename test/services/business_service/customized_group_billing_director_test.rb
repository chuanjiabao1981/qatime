require 'test_helper'

module LiveServiceTest
  class CustomizedGroupBillingDirectorTest < ActiveSupport::TestCase
    # 单个购买结账测试
    # 单个学生结账
    # 基础服务费 2
    # 教师分成 70% 98 * 0.7
    # 发行商分成 5%
    # 经销商分成 15%
    # 平台分成 10%
    test 'test billing a ticket' do
      @publish_account = workstations(:workstation_zhuji).cash_account
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!
      @sell_account = workstations(:workstation1).cash_account

      lesson = live_studio_events(:billing_scheduled_lesson_one)
      director = BusinessService::CustomizedGroupBillingDirector.new(lesson)
      assert_difference "Payment::BillingItem.count", 5, '账单条目数量不正确' do
        assert_difference "@system_account.reload.balance.to_f", (2 + 98 * 0.1) - 100, "系统收入不正确" do
          assert_difference "@publish_account.reload.balance.to_f", 98 * 0.05, "发行商收入不正确" do
            assert_difference "@sell_account.reload.balance.to_f", 98 * 0.15, "经销商收入不正确" do
              assert_difference "@teacher_account.reload.balance.to_f", 98 * 0.7, "教师收入不正确" do
                director.billing_lesson
              end
            end
          end
        end
      end

      assert lesson.reload.completed?, "结账状态不正确 #{lesson.status}"
    end

    # 多个购买结账测试
    # 基础服务费 2
    # 教师分成 70% (98 * 0.7 + 48 * 0.7)
    # 发行商分成 5% (98 * 0.05 + 48 * 0.05)
    # 经销商1分成 15% (98 * 0.15)
    # 经销商2分成 10% (48 * 0.10)
    # 平台分成 (98 * 0.10) + (48 * 0.15)
    test 'test billing multiple ticket' do
      @publish_account = workstations(:workstation_zhuji).cash_account
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!
      @sell1_account = workstations(:workstation1).cash_account
      @sell2_account = workstations(:workstation_one).cash_account

      lesson = live_studio_events(:billing_offline_lesson_one)
      director = BusinessService::CustomizedGroupBillingDirector.new(lesson)
      assert_difference "Payment::BillingItem.count", 10, '账单条目数量不正确' do
        assert_difference "@system_account.reload.balance.to_f", (4 + 98 * 0.1 + 48 * 0.15) - 100 - 50, "系统收入不正确" do
          assert_difference "@publish_account.reload.balance.to_f", (98 * 0.05 + 48 * 0.05), "发行商收入不正确" do
            assert_difference "@sell2_account.reload.balance.to_f", 48 * 0.1, "经销商2收入不正确" do
              assert_difference "@sell1_account.reload.balance.to_f", (98 * 0.15).round(2), "经销商1收入不正确" do
                assert_difference "@teacher_account.reload.balance.to_f", (98 * 0.7 + 48 * 0.7).round(2), "教师收入不正确" do
                  director.billing_lesson
                end
              end
            end
          end
        end
      end

      assert lesson.reload.completed?, "结账状态不正确 #{lesson.status}"
    end
  end
end
