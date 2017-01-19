require 'test_helper'

module LiveServiceTest
  class BillingDirectorTest < ActiveJob::TestCase
    # 老师创建的辅导班课程结账
    # 老师收入没有工作站分成
    test 'billing a lesson of course created by teacher' do
      @lesson = live_studio_lessons(:lesson_one_of_course_for_billing_one)
      @course = @lesson.course
      @workstation = @course.workstation
      @teacher = @lesson.teacher
      assert_difference "@teacher.cash_account!.total_income.to_f", 188, "课程结账教师收入不正确" do
        assert_difference "@workstation.cash_account!.total_income.to_f", 37.6, "课程结账工作站收入不正确" do
          assert_difference "CashAdmin.current!.cash_account!.total_income.to_f", 24.4, "课程结账系统收入不正确" do
            assert_difference "CashAdmin.current!.cash_account!.total_expenditure.to_f", 250, "课程结账系统支出不正确" do
              LiveService::BillingDirector.new(@lesson).billing
            end
          end
        end
      end
      assert @lesson.completed?, "课程结账状态不正确"
    end

    # 代理商邀请创建的辅导班
    # 代理商根据辅导班分成比例获得授课分成
    test 'billing a lesson of course invited by manager' do
      @lesson = live_studio_lessons(:lesson_one_of_course_for_billing_two)
      @course = @lesson.course
      @workstation = @course.workstation
      @teacher = @lesson.teacher
      assert_difference "@teacher.cash_account!.total_income.to_f", 100.8, "课程结账教师收入不正确" do
        assert_difference "@workstation.cash_account!.total_income.to_f", 34.56, "课程结账工作站收入不正确" do
          assert_difference "CashAdmin.current!.cash_account!.total_income.to_f", 14.64, "课程结账系统收入不正确" do
            assert_difference "CashAdmin.current!.cash_account!.total_expenditure.to_f", 150, "课程结账系统支出不正确" do
              LiveService::BillingDirector.new(@lesson).billing
            end
          end
        end
      end
    end

    # 没有工作站的地区课程结账
    # 结账逻辑调整
    test 'billing a lesson without workstation' do
      @lesson = live_studio_lessons(:lesson_one_of_course_for_billing_three)
      @course = @lesson.course
      @workstation = workstations(:workstation_default)
      @teacher = @lesson.teacher
      assert_difference "@teacher.cash_account!.total_income.to_f", 110.4, "课程结账教师收入不正确" do
        assert_difference "@workstation.cash_account!.reload.total_income.to_f", 22.08, "课程结账工作站收入不正确" do
          assert_difference "CashAdmin.current!.cash_account!.total_income.to_f", 17.52, "课程结账系统收入不正确" do
            assert_difference "CashAdmin.current!.cash_account!.total_expenditure.to_f", 150, "课程结账系统支出不正确" do
              LiveService::BillingDirector.new(@lesson).billing
            end
          end
        end
      end
    end
  end
end
