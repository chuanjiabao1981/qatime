require 'test_helper'

module LiveServiceTest
  class CourseBillingDirectorTest < ActiveSupport::TestCase
    # 单个购买结账测试
    # 单个学生结账
    # 视频时长 30分钟
    # 教师分成 50%
    # 发行商分成 10%
    # 经销商分成 30%
    # 平台分成 10%
    test 'test billing a ticket' do
      @publish_account = workstations(:workstation_one).cash_account
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!
      @sell_account = workstations(:workstation1).cash_account

      lesson = live_studio_lessons(:lesson_one_of_billing_course_one)
      ticket = live_studio_tickets(:ticket_one_of_billing_course_one)
      ticket_item = ticket.ticket_items.find_by(target: lesson)
      director = BusinessService::CourseBillingDirector.new(lesson)
      assert_difference "Payment::BillingItem.count", 5, '账单条目数量不正确' do
        assert_difference "@system_account.reload.balance.to_f", -42.3, "系统收入不正确" do
          assert_difference "@publish_account.reload.balance.to_f", 4.7, "发行商收入不正确" do
            assert_difference "@sell_account.reload.balance.to_f", 14.1, "经销商收入不正确" do
              assert_difference "@teacher_account.reload.balance.to_f", 23.5, "教师收入不正确" do
                director.billing_ticket(nil, ticket_item)
              end
            end
          end
        end
      end

      assert ticket_item.reload.finished?, "结账状态不正确"
    end

    # 结账异常测试
    test 'test billing a ticket with error' do
      lesson = live_studio_lessons(:lesson_two_of_billing_course_one)
      ticket = live_studio_tickets(:ticket_four_of_billing_course_one)
      ticket_item = ticket.ticket_items.find_by(target: lesson)

      @publish_account = lesson.course.workstation.cash_account
      @teacher_account = lesson.course.teacher.cash_account
      @system_account = CashAdmin.current!.cash_account!

      director = BusinessService::CourseBillingDirector.new(lesson)
      assert_no_difference "@system_account.reload.balance.to_f", "系统支出没有回滚" do
        assert_no_difference "@publish_account.reload.balance.to_f", "发行商收入没有回滚" do
          assert_no_difference "@teacher_account.reload.balance.to_f", "教师收入没有回滚" do
            assert_no_difference "Payment::BillingItem.count", "错误创建账单项目" do
              assert_raises StandardError do
                director.billing_ticket(nil, ticket_item) do
                  raise StandardError, "测试异常"
                end
              end
            end
          end
        end
      end
    end

    # 学生自愿购买结账
    test 'test billing a ticket without seller' do
      @publish_account = workstations(:workstation_one).cash_account
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.current!.cash_account!
      @sell_account = Workstation.default.cash_account

      lesson = live_studio_lessons(:lesson_one_of_billing_course_one)
      ticket = live_studio_tickets(:ticket_three_of_billing_course_one)
      ticket_item = ticket.ticket_items.find_by(target: lesson)

      director = BusinessService::CourseBillingDirector.new(lesson)
      assert_difference "Payment::BillingItem.count", 5, '账单条目数量不正确' do
        assert_difference "@system_account.reload.balance.to_f", -42.3, "系统收入不正确" do
          assert_difference "@publish_account.reload.balance.to_f", 4.7, "发行商收入不正确" do
            assert_difference "@sell_account.reload.balance.to_f", 14.1, "销售佣金没有正确进入默认工作站" do
              assert_difference "@teacher_account.reload.balance.to_f", 23.5, "教师收入不正确" do
                director.billing_ticket(nil, ticket_item)
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
      ticket_item = ticket.ticket_items.find_by(target: lesson)

      @publish_account = lesson.course.workstation.cash_account
      @teacher_account = lesson.course.teacher.cash_account
      @system_account = CashAdmin.current!.cash_account!

      assert_no_difference "@system_account.reload.balance.to_f", "系统支出没有回滚" do
        assert_no_difference "@publish_account.reload.balance.to_f", "发行商收入没有回滚" do
          assert_no_difference "@teacher_account.reload.balance.to_f", "教师收入没有回滚" do
            assert_no_difference "Payment::BillingItem.count", "错误创建账单项目" do
              assert_raises(Payment::TotalPercentInvalid) do
                BusinessService::CourseBillingDirector.new(lesson).billing_ticket(nil, ticket_item)
              end
            end
          end
        end
      end
    end

    # 混合结账测试
    # 视频时长 100分钟
    # @sell1_account 3个学生
    # @sell2_account 2个学生
    # @sell3_account 1个学生
    # @sell4_account 1个学生(直接购买)
    # 教师分成 45%
    # 发行分成 15%
    # 销售1分成 30% 10%
    # 销售2分成 20% 20%
    # 销售3分成 25% 15%
    # 销售4分成 30% 10%
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
      director = BusinessService::CourseBillingDirector.new(lesson)

      assert_difference "Payment::LiveCourseBilling.count", 1, "总账单创建失败" do
        assert_difference "Payment::LiveCourseTicketBilling.count", 7, '结账数量不正确' do
          assert_difference "@system_account.reload.balance.to_f", -302.5, "系统收入不正确" do
            assert_difference "@publish_account.reload.balance.to_f", 52.5, "发行商收入不正确" do
              assert_difference "@sell1_account.reload.balance.to_f", 45, "经销商1收入不正确" do
                assert_difference "@sell2_account.reload.balance.to_f", 20.0, "经销商2收入不正确" do
                  assert_difference "@sell3_account.reload.balance.to_f", 12.5, "经销商3收入不正确" do
                    assert_difference "@sell4_account.reload.balance.to_f", 15, "默认工作站收入不正确" do
                      assert_difference "@teacher_account.reload.balance.to_f", 157.5, "教师收入不正确" do
                        director.billing_lesson
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      b = Payment::LiveCourseBilling.last
      assert_equal 420.0, b.total_money.to_f, "账单金额不正确"
      assert_equal lesson.course.teacher.id, b.from_user.id, "账单参与者记录错误"
      assert lesson.reload.completed?, "课程结账状态不正确"
    end

    # 跨区销售结账
    # 视频时长 90分钟
    # 价格 50
    # @sell1_account 1个学生
    # @sell2_account 1个学生
    # @sell3_account 1个学生(直接购买)
    # 教师分成 35
    # 发行收入 10
    # 销售1分成 45 = 55 - 10
    # 销售2分成 35 = 55 - 20
    # 销售3分成 40 = 55 - 15
    # 总金额 50 * 3 = 150
    # 系统服务费 3 * 0.1 * 90 = 27
    # 教师佣金 (150 - 27) * 0.35 = 43.05
    # 发行佣金 (150 - 27) * 0.1 = 12.3
    # @sell1_account销售佣金 (50 - 9) * 0.45 = 18.45
    # @sell2_account销售佣金 (50 - 9) * (0.55 - 0.2) = 14.35
    # @sell3_account销售佣金 (50 - 9) * (0.55 - 0.15) = 16.4
    test 'test multipul platform percentage sell billing' do
      @publish_account = workstations(:workstation_one).cash_account # 发行商
      @sell2_account = workstations(:workstation_zhuji).cash_account # 跨区销售
      @sell3_account = Workstation.default.cash_account # 直接购买
      @teacher_account = users(:teacher1).cash_account
      @system_account = CashAdmin.cash_account!

      lesson = live_studio_lessons(:lesson_one_of_billing_course_three)
      director = BusinessService::CourseBillingDirector.new(lesson)

      assert_difference "Payment::LiveCourseBilling.count", 1, "总账单创建失败" do
        assert_difference "Payment::LiveCourseTicketBilling.count", 3, '结账数量不正确' do
          assert_difference "@system_account.reload.balance.to_f", -104.55, "系统收入不正确" do
            assert_difference "@publish_account.reload.balance.to_f", 30.75, "发行商收入不正确" do
              assert_difference "@sell2_account.reload.balance.to_f", 14.35, "经销商2收入不正确" do
                assert_difference "@sell3_account.reload.balance.to_f", 16.4, "默认工作站收入不正确" do
                  assert_difference "@teacher_account.reload.balance.to_f", 43.05, "教师收入不正确" do
                    director.billing_lesson
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
