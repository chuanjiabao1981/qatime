require 'test_helper'
require "database_cleaner"

module LiveStudio
  class VideoCourseTest < ActionDispatch::IntegrationTest
    def setup
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student_balance)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as @student
      Capybara.use_default_driver
      DatabaseCleaner.clean
    end

    # 标签过滤测试
    test 'buy a video course' do
      @video_course = live_studio_video_courses(:published_video_course1)
      visit live_studio.new_video_course_order_path(@video_course)
      choose "order_pay_type_account"
      assert_difference "Payment::Order.count", 1, "下单失败" do
        click_on '立即支付'
        sleep 1
      end
      fill_in :payment_password, with: '123123'
      assert_difference "@video_course.reload.buy_tickets_count", 1, "发货失败" do
        assert_difference "@student.cash_account.reload.balance.to_f", -201, "余额支付失败" do
          click_on '确认支付'
          sleep 1
        end
      end
    end
  end
end