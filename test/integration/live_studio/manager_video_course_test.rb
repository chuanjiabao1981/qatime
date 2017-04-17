require 'test_helper'

module LiveStudio
  class ManagerVideoCourseTest < ActionDispatch::IntegrationTest
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

    test "manager view video course list" do
      click_on "视频课"
      assert page.has_content?('已发布'), "全部列表没有显示已发布的视频课"
      assert page.has_link?('视频课列表')

      click_on "视频课列表", match: :first
      assert page.has_content?('销售分成')
      assert page.has_content?('二维码')
      assert page.has_button?('生成'), "没有二维码生成按钮"
      assert page.has_select?('q_workstation_id_eq')
      assert page.has_select?('q_subject_eq')
      assert page.has_select?('q_grade_eq')

      select '高二', from: 'q_grade_eq'
      assert page.has_content? '高二'
      assert_equal page.all('.admin-list-con table tr').size, 2

      page.first(:css, 'input.send_qa_code').click
    end
  end
end
