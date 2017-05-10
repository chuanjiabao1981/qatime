require 'test_helper'

module LiveStudio
  class AdminCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @admin = users(:admin)
      log_in_as(@admin)
    end

    def teardown
      logout_as(@admin)
      Capybara.use_default_driver
    end

    test "admin view course list" do
      click_on "直播课列表"
      assert page.has_content?('开课中'), "全部列表没有显示开课中辅导班"
      assert page.has_content?('招生中'), "全部列表没有显示招生中辅导班"
      assert page.has_no_content?('审核中'), "未审核辅导班显示"
      assert page.has_no_content?('审核被拒'), "未审核通过辅导班显示"
      select('英语', from: 'subject')
      assert_equal 7, page.all(".admin-list-con tr").size, "英语辅导数量不正确"
      select('高一', from: 'grade')
      assert_equal 4, page.all(".admin-list-con tr").size, "高一英语辅导数量不正确"
      select('开课中', from: 'status')
      assert_equal 2, page.all(".admin-list-con tr").size, "高一英语未开课辅导数量不正确"
      click_on("清空")
      assert page.all(".admin-list-con tr").size > 10, "清空按钮无效"
    end
  end
end
