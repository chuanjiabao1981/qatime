require 'test_helper'

module LiveStudio
  # 课程结算
  class LessonBillingTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @teacher = users(:english_teacher)

      log_in_as(@teacher)
    end

    def teardown
      logout_as(@teacher)
      Capybara.use_default_driver
    end

    test "teacher start live" do
      course = live_studio_courses(:course_with_lessons)
      lesson = live_studio_lessons(:english_lesson_today)
      visit live_studio.teacher_course_path(course)
      click_on("准备上课")
      page.assert_selector("a.live")
      lesson.reload
      assert_equal("ready", lesson.status)
      click_on("开始直播")
      page.assert_selector("a.finish")
      lesson.reload
      assert_equal("teaching", lesson.status)
    end

    test "lesson finish and billing" do
      course = live_studio_courses(:course_with_lessons)
      lesson = live_studio_lessons(:english_lesson_onlive)
      visit live_studio.teacher_course_path(course)
      click_on("结束直播")
      lesson.reload
      assert_equal("completed", lesson.status)
    end

    test "lesson complete and billing and cash" do
      course = live_studio_courses(:course_with_lessons)
      lesson = live_studio_lessons(:english_lesson_finished)
      @workstation = workstations(:workstation_one)
      assert_difference '@workstation.cash_account!.reload.balance.to_f', 48.0 do
        assert_difference '@teacher.cash_account!.reload.balance.to_f', 12.0 do
          assert_difference 'CashAdmin.current.cash_account!.balance.to_f', -60.0 do
            visit live_studio.teacher_course_path(course)
            click_on("立即结算")
          end
        end
      end
      lesson.reload
      assert_equal("completed", lesson.status)
    end

  end
end
