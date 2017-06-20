require 'test_helper'

module Wap
  module LiveStudio
    class CoursesTest < ActionDispatch::IntegrationTest
      def setup
        @headless = Headless.new
        @headless.start
        Capybara.current_driver = :selenium_chrome
        @coupon_one = payment_coupons(:coupon_one)
        @student = users(:student1)
      end

      def teardown
        Capybara.use_default_driver
      end

      test 'student weixin course show page' do
        course = live_studio_courses(:course_preview_four)
        weixin_url = wap_live_studio_course_path(course, come_from: 'weixin', coupon_code: @coupon_one.code)
        visit weixin_url
        assert page.has_content?(course.name)

        assert page.has_content?('基本属性')
        assert page.has_content?('课程标签')
        assert page.has_content?('课程目标')
        assert page.has_content?('适合人群')
        assert page.has_content?('学习须知')
      end

      test 'student buy course from weixin' do
        course = live_studio_courses(:course_preview_four)
        weixin_url = wap_live_studio_course_path(course, come_from: 'weixin', coupon_code: @coupon_one.code)
        visit weixin_url
        assert page.has_content?(course.name)

        assert page.has_content?('下载APP'), "默认下载条未显示"
        find(:css, ".close_alert").click
        assert !page.has_content?('下载APP'), "默认下载条未关闭"

        assert page.has_content?('加入试听')
        assert page.has_content?('立即报名')

        click_on "加入试听"
        assert page.has_content?('此功能需要打开客户端才能使用'), "下载app提示未弹出"

        visit weixin_url
        click_on "立即报名"
        assert page.has_content?('您没有权限进行这个操作!'), "未跳转到登录页面"

        fill_in :user_login_account, with: @student.email
        fill_in :user_password, with: 'password'
        click_on "立即登录"
        assert page.has_content?('订单确认'), "登录后未返回下单页面"
      end

      test 'student buy course from weixin download page' do
        course = live_studio_courses(:course_preview_four)
        weixin_url = wap_live_studio_course_path(course, come_from: 'weixin', coupon_code: @coupon_one.code)
        visit weixin_url
        click_on "下载APP"
        assert page.has_link?('下载'), "未跳转到下载页面"
        assert page.has_content?('仅支持安卓下载')

        visit weixin_url
        click_on "加入试听"
        sleep(3)
        new_window = window_opened_by { click_on '下载客户端' }
        within_window new_window do
          assert page.has_link?('下载'), "未跳转到下载页面"
        end
        new_window.close
      end
    end
  end
end
