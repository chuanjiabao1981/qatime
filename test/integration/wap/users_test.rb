require 'test_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

module Wap
  class UsersTest < ActionDispatch::IntegrationTest

    def setup
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      Capybara.use_default_driver
    end

    test 'regist student from qr_code' do
      course = live_studio_courses(:course_preview_four)
      coupon_one = payment_coupons(:coupon_one)
      redirect_url = wap_live_studio_course_path(course, come_from: 'weixin', coupon_code: coupon_one.code)
      visit new_wap_user_path(redirect_url: redirect_url)

      fill_in :student_login_mobile, with: '13800001111'
      click_on "获取校验码", match: :first
      fill_in :student_captcha_confirmation, with: '1234'
      fill_in :student_password, with: 'pa123456'
      fill_in :student_password_confirmation, with: 'pa123456'
      find(:css, "#accept").set(true)

      sleep(2)
      assert_difference 'User.count', 1 do
        click_on "提交", match: :first
      end
      assert page.has_content?(course.name), "辅导班页面跳转失败"

    end

  end
end
