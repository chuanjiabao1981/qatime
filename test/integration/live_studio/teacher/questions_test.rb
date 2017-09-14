require 'test_helper'

module LiveStudio
  module Teacher
    # 问题测试
    class QuestionsTest < ActionDispatch::IntegrationTest
      def setup
        @routes = Engine.routes
        @headless = Headless.new
        @headless.start
        Capybara.current_driver = :selenium_chrome
        @teacher = users(:teacher_with_chat_account)
        new_log_in_as(@teacher)
      end

      def teardown
        new_logout_as(@teacher) if @teacher
        Capybara.use_default_driver
      end

      # 我的问题
      test "teacher my questions" do
        @group = live_studio_groups(:schedule_published_group1)
        visit get_home_url(@teacher)
        click_on '提问管理'
        assert page.has_content?('地球为什么是圆的'), "问题标题未显示?"
        assert page.has_content?('student_with_course'), "学生姓名没显示?"
        assert page.has_content?(@group.name), "相关课程显示错误"
        click_on '已回复'
        assert page.has_no_content?('地球为什么是圆的'), "待回复问题错误显示?"
        assert page.has_content?('奶牛为什么能产牛奶'), "已回复显示错误"
        click_on '待回复'
        click_on '地球为什么是圆的'
        assert_current_path live_studio.customized_group_path(@group)
      end
    end
  end
end
