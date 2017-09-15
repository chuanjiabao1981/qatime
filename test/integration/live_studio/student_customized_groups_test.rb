require 'test_helper'

module LiveStudio
  # 我的专属课测试
  class StudentCustomizedGroupTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student_view_customized_group)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "visit student customized group page" do
      visit live_studio.student_customized_groups_path(@student)
      assert page.has_content? '我的专属课'
      assert page.has_link? '待开课'
      assert page.has_link? '已开课'
      assert page.has_link? '已结束'
      assert page.has_link? '我的专属课published'
      click_on '已开课'
      assert page.has_link? '我的专属课teaching'

      click_on '已结束'
      assert page.has_link? '我的专属课completed'
    end

    test "visit student customized group play page" do
      customized_group = live_studio_groups(:teaching_group_for_student_view1)
      visit live_studio.customized_group_path(customized_group)
      click_on '开始学习'
      assert page.has_link?(customized_group.teacher.name), '老师未显示'
      assert page.has_content?('线上直播')
      assert page.has_content?('线下讲课')
      assert page.has_content?(customized_group.name), '直播课程名称未显示'
    end
  end
end
