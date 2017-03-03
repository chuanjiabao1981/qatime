require 'test_helper'

module Wap
  module LiveStudio
    class CoursesTest < ActionDispatch::IntegrationTest

      def setup
        @headless = Headless.new
        @headless.start
        Capybara.current_driver = :selenium_chrome

        @student = users(:student1)
      end

      def teardown
        Capybara.use_default_driver
      end

      test 'student buy course from weixin' do
        course = live_studio_courses(:course_preview_four)
        weixin_url = wap_live_studio_course_path(course, come_from: 'weixin', coupon_code: 'correct_code')
        visit weixin_url
        assert page.has_content?(course.name)

        assert page.has_content?('下载APP'), "默认下载条未显示"
        find(:css, ".close_alert").click
        assert !page.has_content?('下载APP'), "默认下载条未关闭"

        assert page.has_content?('加入试听')
        assert page.has_content?('立即报名')

        click_on "加入试听"
        assert page.has_content?('此功能需要打开客户端才能使用'), "下载app提示未弹出"
        click_on '×'

        click_on "立即报名"
        assert page.has_content?('您没有权限进行这个操作!'), "未跳转到登录页面"

        fill_in :user_login_account, with: @student.email
        fill_in :user_password, with: 'password'
        click_on "立即登录"

        assert page.has_content?('支付'), "登录后未返回下单页面"
      end

    end
  end
end
