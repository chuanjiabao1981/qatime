require 'test_helper'

module Chat
  class ChatAccountCreateTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:no_chat_account_student)

      account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: SecureRandom.hex(16), token: SecureRandom.hex(16) } }.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)

      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "student taste course without account" do
      course = live_studio_courses(:tasting_course)
      visit live_studio.courses_index_path(student_id: @student)

      assert_difference "course.reload.taste_tickets.count", 1, "不能正确生成试听证" do
        assert_difference "@student.live_studio_courses.count", 1, "不能正确试听辅导班" do
          visit live_studio.course_path(course)
          click_on("taste-course-#{course.id}")
          sleep 2
          # assert page.find("#taste-course-#{course.id}")['class'].include?('disabled'), '不能正确点击试听按钮'
          @student.reload
          assert_not_nil @student.chat_account, "没有正确创建云信ID"
          @student.chat_account.destroy
        end
      end
    end

    test "student buy course without account" do
      visit live_studio.courses_index_path(student_id: @student)
      course_preview = live_studio_courses(:course_preview)
      assert_difference '@student.orders.count', 1, "辅导班下单失败" do
        visit live_studio.course_path(course_preview)
        click_link '立即报名'
        # click_on("buy-course-#{course_preview.id}")
        choose('微信支付')
        click_on '立即支付'
        sleep(3)

        @student.reload
        assert_not_nil @student.chat_account
        @student.chat_account.destroy
      end
    end
  end
end
