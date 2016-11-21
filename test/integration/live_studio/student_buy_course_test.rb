require 'test_helper'

module LiveStudio
  class StudentBuyCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = ::Student.find(users(:student_with_order2).id)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    # test "student search course" do
    #   course_init = live_studio_courses(:course_init)
    #   visit live_studio.courses_index_path(student_id: @student)
    #   course_preview_two = live_studio_courses(:course_preview_two)
    #   course_teaching = live_studio_courses(:course_teaching)
    #   assert(page.has_no_link?("buy-course-#{course_init.id}"), "购买链接错误显示")
    #   assert(page.has_link?("buy-course-#{course_preview_two.id}"), "不能正常购买辅导班")
    #   assert(page.has_link?("buy-course-#{course_teaching.id}"), "不能正常购买辅导班")
    # end

    test "student buy course" do
      visit live_studio.courses_index_path(student_id: @student)
      course_preview = live_studio_courses(:course_preview)
      assert_difference '@student.orders.count', 1, "辅导班下单失败" do
        visit live_studio.course_path(course_preview)
        click_link '立即报名'
        choose "order_pay_type_weixin"
        click_on '立即付款'
        page.has_content? "提示：如支付遇到问题，请拨打电话 010-58442007"
      end
    end

    test "student pay order" do
      @order = payment_transactions(:order5)
      visit payment.transaction_path(@order.transaction_no)
      assert has_selector?('.row-list-img img'), "验证码显示不正确"
      assert_difference "CashAdmin.current_cash", @order.amount.to_f, "订单支付完成系统收入不正确" do
        @order.pay_and_ship!
      end
    end

    test "student taste and buy course" do
      course = live_studio_courses(:course_with_lessons)
      visit live_studio.courses_index_path(student_id: @student)
      assert_difference "@student.reload.live_studio_courses.count", 1, "不能正确试听辅导班" do
        assert_difference "@student.reload.live_studio_taste_tickets.count", 1, "不能正确生成试听证" do
          visit live_studio.course_path(course)
          click_on("taste-course-#{course.id}")
          sleep 2
        end
      end
    end

    test "student buy tasting course" do
      course = live_studio_courses(:tasting_course)
      visit live_studio.courses_index_path(student_id: @student)
      assert_difference "@student.reload.orders.count", 1, "正在试听的辅导班下单失败" do
        # visit live_studio.new_course_order_path(course)
        # click_on("buy-course-#{course.id}")
        visit live_studio.course_path(course)
        click_link '立即报名'
        choose "order_pay_type_weixin"
        click_on '立即付款'
        sleep(1)
      end
    end

    # 余额支付购买辅导班
    test "buy course with account balance" do
      @student_balance = users(:student_balance)
      new_log_in_as(@student_balance)
      visit live_studio.courses_index_path(student_id: @student_balance)
      course = live_studio_courses(:course_preview_three)
      assert_difference "@student_balance.cash_account!.reload.balance.to_f", -50, "没有正确扣除余额" do
        assert_difference "@student_balance.cash_account!.reload.total_expenditure.to_f", 50, "总消费计算不正确" do
          assert_difference "Payment::ConsumptionRecord.count", 1, "没有生成消费记录" do
            assert_difference '@student_balance.reload.orders.count', 1, "辅导班下单失败" do
              visit live_studio.course_path(course)
              click_link '立即报名'
              choose "order_pay_type_account"
              click_on '立即付款'
              page.has_content? "提示：如支付遇到问题，请拨打电话 010-58442007"
            end
          end
        end
      end
    end
  end
end
