require 'test_helper'

module LiveStudio
  module Student
    # 作业测试
    class StudentHomewokrsTest < ActionDispatch::IntegrationTest
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

      # 学生个人中心我的作业
      test "student my student homewokrs" do
        visit get_home_url(@student)
        click_on '我的作业'
        assert page.has_content?("第2个作业"), '未交作业未显示'
        assert page.has_no_content?("第3个作业"), '已交作业错误显示'
        click_on "已交"
        assert page.has_no_content?("第2个作业"), '未交作业错误显示'
        assert page.has_content?("第3个作业"), '已交作业未显示'
        click_on '已批'
        assert page.has_no_content?("第2个作业"), '未交作业错误显示'
        assert page.has_no_content?("第3个作业"), '已交作业错误显示'
      end
    end
  end
end
