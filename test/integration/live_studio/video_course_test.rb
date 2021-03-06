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
      account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: 'xxxxx', token: 'thisisatoken' } }.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as @student
      Capybara.use_default_driver
      DatabaseCleaner.clean
    end

    test 'buy off shelve video course' do
      course = live_studio_video_courses(:completed_video_course)
      visit live_studio.video_course_path(course)
      assert page.has_link? '已下架'
      assert page.has_no_link? '立即报名'

      visit live_studio.new_video_course_order_path(course)
      assert page.has_content? '该课程已下架!'
    end

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

    test 'buy free video course' do
      free_video_course = live_studio_video_courses(:published_video_course2)
      visit live_studio.video_course_path(free_video_course)
      click_on '立即学习', match: :first
      sleep(1)
      assert page.has_link? '观看'
      assert free_video_course.reload.bought_by?(@student), '购买不成功'
    end
  end
end
