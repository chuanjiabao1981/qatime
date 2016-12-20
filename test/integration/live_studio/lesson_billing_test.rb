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
      visit live_studio.course_path(@course)
      click_on '立即报名'
      choose('order_pay_type_account')
      fill_in :order_payment_password, with: 'password'
      click_on '立即付款'
      new_logout_as(student)
      # 票据准确性
      assert_equal @course.buy_tickets.count, 1
      assert_equal @course.buy_tickets.first.got_lesson_ids.count, 2

      lesson = @course.lessons.first
      lesson.teach!

      LiveService::BillingDirector.new(lesson).billing
      sleep 2
      # todo 完善测试结果
      assert_equal @teacher.cash_account!.balance, (@course.lesson_price * @course.teacher_percentage.to_f / 100)
      # 系统账户收支
      assert_equal CashAdmin.first.cash_account.consumption_records.last.different, @course.lesson_price
      assert_equal CashAdmin.first.cash_account.earning_records.last.different, @course.price
    end



    # test "teacher start live" do
    #   course = live_studio_courses(:course_with_lessons)
    #   lesson = live_studio_lessons(:english_lesson_today)
    #   visit live_studio.teacher_course_path(@teacher,course)
    #   click_on("准备上课")
    #   page.assert_selector("a.live")
    #   lesson.reload
    #   assert_equal("ready", lesson.status)
    #   click_on("开始直播")
    #   page.assert_selector("a.finish")
    #   lesson.reload
    #   assert_equal("teaching", lesson.status)
    # end

    # test "lesson finish and billing" do
    #   course = live_studio_courses(:course_with_lessons)
    #   lesson = live_studio_lessons(:english_lesson_onlive)
    #   visit live_studio.teacher_course_path(@teacher, course)
    #   click_on("结束直播")
    #   lesson.reload
    #   assert_equal("closed", lesson.status)
    # end
  end
end
