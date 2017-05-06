require 'test_helper'

module LiveStudio
  class ManagerCourseRequestTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager_zhuji)
      log_in_as(@manager)
    end

    def teardown
      logout_as(@manager)
      Capybara.use_default_driver
    end

    # test "manager view course request list" do
    #   click_on "直播课代销"
    #   click_on "招生审核"
    #   assert page.find(".admin-list-con").has_no_content?("未审核"), "未审核请求没有正确显示操作按钮"
    #   assert_equal 2, page.all(".admin-list-con tr").size, "未审核请求数量不正确"
    #   click_on "已审核"
    #   assert_equal 4, page.all(".admin-list-con tr").size, "已审核请求数量不正确"
    #   click_on "未审核"
    #   request_to_accept = live_studio_course_requests(:request_one)
    #   find_link("通过", href: live_studio.accept_station_workstation_course_request_path(request_to_accept.workstation, request_to_accept)).click
    #   assert request_to_accept.reload.accepted?, "通过失败"
    #   assert request_to_accept.reload.course.teaching?, "通过后辅导班状态不正确"
    # end
  end
end
