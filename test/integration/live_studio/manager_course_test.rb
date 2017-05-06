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
    end

    def teardown
      new_logout_as(@manager)
      Capybara.use_default_driver
    end

    test "manager view course list" do
      click_on "直播课代销"
      assert page.has_content?('招生中'), "全部列表没有显示招生中辅导班"
      assert page.has_link?('直播课代销')
      assert page.has_link?('发行/经销')

      click_on "发行/经销"
      assert page.has_content?('经销分成')
      assert page.has_content?('招生购买')
      assert page.has_select?('select_workstation_id')
      assert page.has_select?('subject')
      assert page.has_select?('grade')
      assert page.has_select?('status', with_options: %w[招生中 开课中])

      assert page.has_link?('我的发行')
      assert page.has_link?('我的经销')

      click_on "我的发行"
      assert page.has_content?('老师分成')

      click_on "直播课代销", match: :first
      assert page.has_content?('经销分成')
      assert page.has_content?('二维码')
      assert page.has_button?('生成'), "没有二维码生成按钮"
      assert page.has_select?('select_workstation_id')
      assert page.has_select?('subject')
      assert page.has_select?('grade')
      assert page.has_select?('status', with_options: %w[招生中 开课中])

      page.first(:css, 'input.send_qa_code').click

      get page.first(:css, 'input.send_qa_code').native.attribute("data-url")
      assert_response(:success)
      assert_equal @response.content_type.to_s, 'image/png', "未下载二维码"
      assert @response.header['Content-Disposition'].include?('attachment'), "未下载二维码"
      reset!

    end
  end
end
