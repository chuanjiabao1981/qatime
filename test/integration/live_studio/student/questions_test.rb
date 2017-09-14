require 'test_helper'

module LiveStudio
  module Student
    # 问题测试
    class QuestionsTest < ActionDispatch::IntegrationTest
      def setup
        @routes = Engine.routes
        @headless = Headless.new
        @headless.start
        Capybara.current_driver = :selenium_chrome
        @student = users(:student_one_with_course)
        new_log_in_as(@student)
      end

      def teardown
        new_logout_as(@student) if @student
        Capybara.use_default_driver
      end

      # 我的问题
      test "teacher my questions" do
        @group = live_studio_groups(:schedule_published_group1)
        visit get_home_url(@student)
        click_on '我的提问'
        assert page.has_content?('地球为什么是圆的'), "问题标题未显示?"
        assert page.has_content?('student_with_course'), "学生姓名没显示?"
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
