require 'test_helper'

module LiveServiceTest
  class VideoCourseBillingDirectorTest < ActiveSupport::TestCase
    # 单价 360
    # 服务费 50
    # 教师分成 60% 300 * 0.6 = 186
    # 发行分成 5% 300 * 0.05 = 15.5
    # 销售非诚 25% 300 * 0.25 = 77.5
    # 平台分成 10% 300 * 0.1 = 31
    test 'test billing a video course' do
      @ticket = live_studio_tickets(:video_course_buy_ticket1)
      @publish_account = workstations(:workstation_one).cash_account
      @sell_account = Workstation.default.cash_account!
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!

      director = BusinessService::VideoCourseBillingDirector.new(@ticket)
      assert_difference "Payment::BillingItem.count", 5, '账单条目数量不正确' do
        assert_difference "@system_account.reload.balance.to_f", -279, "系统收入不正确" do
          assert_difference "@publish_account.reload.balance.to_f", 15.5, "发行商收入不正确" do
            assert_difference "@sell_account.reload.balance.to_f", 77.5, "销售收入不正确" do
              assert_difference "@teacher_account.reload.balance.to_f", 186, "教师收入不正确" do
                director.billing_ticket
              end
            end
          end
        end
      end

      assert @ticket.payment_order.reload.completed?, "结账状态不正确"
    end

    test 'test billing a video course fail' do
      @ticket = live_studio_tickets(:video_course_buy_ticket2)
      @publish_account = workstations(:workstation_one).cash_account
      @sell_account = Workstation.default.cash_account!
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!

      director = BusinessService::VideoCourseBillingDirector.new(@ticket)
      assert_no_difference "Payment::BillingItem.count", '账单条目数量没有回滚' do
        assert_no_difference "@system_account.reload.balance.to_f", "系统收入没有回滚" do
          assert_no_difference "@publish_account.reload.balance.to_f", "发行商收入没有回滚" do
            assert_no_difference "@sell_account.reload.balance.to_f", "销售收入没有回滚" do
              assert_no_difference "@teacher_account.reload.balance.to_f", "教师收入没有回滚" do
                assert_raises StandardError do
                  director.billing_ticket do
                    raise StandardError, "测试异常"
                  end
                end
              end
            end
          end
        end
      end

      assert_not @ticket.payment_order.reload.completed?, "结账状态不正确"
    end
  end
end
