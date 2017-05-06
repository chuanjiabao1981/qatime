require 'test_helper'

module LiveStudio
  class AdminCourseRequestTest < ActionDispatch::IntegrationTest
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

    # test "admin view course request list" do
    #   click_on "辅导班"
    #   click_on "招生审核"
    #   assert page.find(".admin-list-con").has_content?("未审核"), "有工作站的请求没有正确显示状态"
    #   assert page.has_css?('div.condition-left'), "状态选择按钮不存在"
    #   assert_equal 4, page.all(".admin-list-con tr").size, "未审核请求数量不正确"
    #   click_on "已审核"
    #   assert_equal 4, page.all(".admin-list-con tr").size, "已审核请求数量不正确"
    #   click_on "未审核"
    #   request_to_accept = live_studio_course_requests(:request_two)
    #   request_to_reject = live_studio_course_requests(:request_three)
    #   find_link("通过", href: live_studio.accept_admin_course_request_path(request_to_accept)).click
    #   assert request_to_accept.reload.accepted?, "通过失败"
    #   find_link("驳回", href: live_studio.reject_admin_course_request_path(request_to_reject)).click
    #   assert request_to_reject.reload.rejected?, "驳回失败"
    #   assert request_to_reject.reload.course.rejected?, "驳回后辅导班状态不正确"
    # end
  end
end
