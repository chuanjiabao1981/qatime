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

    test "student buy course and lesson billing " do
      student = users(:student_balance)
      new_log_in_as(student)
      admin_account = CashAdmin.first.cash_account.balance
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

      lesson = @course.lessons.first
      lesson.teach!
      LiveService::BillingDirector.new(lesson).billing
      sleep 2
      money = @course.buy_tickets.where('got_lesson_ids like ?', "% #{lesson.id}\n%").sum(:lesson_price)
      system_money = service_money = LiveStudio::Course::SYSTEM_FEE * lesson.live_count * lesson.real_time
      workstation_money = service_money * LiveStudio::Course::WORKSTATION_PERCENT
      teacher_money = money - system_money
      teacher_percentage_money = (teacher_money * @course.teacher_percentage.to_f / 100)
      system_money -= workstation_money

      # 系统收入 - 学生购买
      assert_equal CashAdmin.first.cash_account.earning_records.first.different.abs, @course.price
      # 系统支出 - 课程结算
      assert_equal CashAdmin.first.cash_account.consumption_records.first.different, -@course.lesson_price
      # 系统收入 - 课程结算 - 服务费
      assert_equal CashAdmin.first.cash_account.earning_records.last.different.abs, system_money.round(2)
      # 系统账户余额 : 购买收入 - 课程单价 + 系统服务费
      assert_equal CashAdmin.first.cash_account.balance, admin_account + @course.price - @course.lesson_price + system_money.round(2)
      # 工作站收入 - 系统分成
      assert_equal @course.workstation.cash_account.earning_records.first.different, workstation_money.round(2)
      # 工作站收入 - 教师分成
      assert_equal @course.workstation.cash_account.earning_records.last.different, teacher_money - teacher_percentage_money
      # 工作站账户余额
      assert_equal @course.workstation.cash_account.balance, workstation_money + teacher_money - teacher_percentage_money
      # 教师账户余额
      assert_equal @teacher.cash_account.balance, teacher_percentage_money
      # 教师收入
      assert_equal @teacher.cash_account.earning_records.first.different, teacher_percentage_money
      # 课程状态
      assert_equal lesson.status, 'completed'
    end

  end
end
