require 'test_helper'

module LiveStudio
  class ManagerCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager_zhuji)
      log_in_as(@manager)
      visit get_home_url(@manager)
    end

    def teardown
      new_logout_as(@manager)
      Capybara.use_default_driver
    end

    test "manager view course list" do
      click_on "课程代销"
      assert page.has_link?('直播课')
      assert page.has_link?('视频课')
      assert page.has_link?('专属课')
      assert page.has_content?('服务扣费')

      assert page.has_content?('销售分成')
      assert page.has_link?('生成二维码'), "没有二维码生成按钮"
      assert page.has_select?('select_workstation_id')
      assert page.has_select?('subject')
      assert page.has_select?('grade')

      get find_link('生成二维码', match: :first).native.attribute('href')

      assert_response(:success)
      assert_equal @response.content_type.to_s, 'image/png', "未下载二维码"
      assert @response.header['Content-Disposition'].include?('attachment'), "未下载二维码"
      reset!

      click_on '视频课'
      assert page.has_content?('视频课名称')
      assert page.has_link?('预览')
      assert page.has_link?('生成二维码')

      click_on '专属课'
      assert page.has_content?('专属课名称')
      assert page.has_link?('预览')
      assert page.has_link?('生成二维码')
    end
  end
end
