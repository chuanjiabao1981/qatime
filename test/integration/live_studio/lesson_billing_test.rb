require 'test_helper'

module LiveStudio
  # 课程结算
  class LessonBillingTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @teacher = users(:teacher1)
      @course = live_studio_courses(:course_maths_seven)
    end

    def teardown
      Capybara.use_default_driver
    end

    test "student buy course" do
      student = users(:student_balance)
      new_log_in_as(student)
      visit live_studio.course_path(@course)
      click_on '立即报名'
      choose('order_pay_type_account')
      click_on '立即支付'
      fill_in 'payment_password', with: '123123'
      click_on '确认支付'

      new_logout_as(student)
      # 票据准确性
      assert_equal @course.buy_tickets.count, 1
      assert_equal @course.buy_tickets.first.got_lesson_ids.count, 2
      assert_equal @course.buy_tickets.first.status, 'active'

      # 系统收入 - 学生购买
      r = CashAdmin.first.cash_account.change_records.first
      assert_equal r.different.abs, @course.price, "系统销售收入不正确"
      assert r.is_a?(Payment::SellRecord), "系统销售收入记录不正确"
    end
  end
end
