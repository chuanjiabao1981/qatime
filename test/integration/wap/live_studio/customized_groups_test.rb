require 'test_helper'

module Wap
  module LiveStudio
    class CustomizedGroupsTest < ActionDispatch::IntegrationTest
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

      test 'student weixin customized group show page' do
        group = live_studio_groups(:published_group1)
        weixin_url = wap_live_studio_customized_group_path(group, come_from: 'weixin', coupon_code: @coupon_one.code)
        visit weixin_url
        assert page.has_content?(group.name)

        assert page.has_content?('基本属性')
        assert page.has_content?('课程目标')
        assert page.has_content?('适合人群')
        assert page.has_content?('学习须知')
        execute_script("$('.details-msg-nav a:last').click();")
        assert page.has_content?('线上直播')
        assert page.has_content?('线下讲课')
      end

      test 'student buy customized group from weixin' do
        group = live_studio_groups(:published_group1)
        weixin_url = wap_live_studio_customized_group_path(group, come_from: 'weixin', coupon_code: @coupon_one.code)
        visit weixin_url

        assert page.has_content?('下载APP'), "默认下载条未显示"
        find(:css, ".close_alert").click
        assert !page.has_content?('下载APP'), "默认下载条未关闭"

        assert page.has_content?('立即报名')

        click_on "立即报名"
        assert page.has_content?('您没有权限进行这个操作!'), "未跳转到登录页面"

        fill_in :user_login_account, with: @student.email
        fill_in :user_password, with: 'password'
        click_on "立即登录"
        assert page.has_content?('订单确认'), "登录后未返回下单页面"
      end
    end
  end
end
