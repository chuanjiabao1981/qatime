require 'test_helper'

module LiveStudio
  module Teacher
    # 作业测试
    class HomewokrsTest < ActionDispatch::IntegrationTest
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

      # 学生提交的作业
      test "teacher my student homewokrs" do
        visit get_home_url(@teacher)
        click_on '作业管理'
        assert page.has_content?('第一个作业'), '待批改作业未显示'
        click_on '一批该'
        assert page.has_no_content?('第一个作业'), '待批改作业错误显示'
      end

      # 我布置的作业
      test "teacher my homewokrs" do
        visit get_home_url(@teacher)
        click_on '作业管理'
        click_on '已布置的作业'
        assert page.has_content?('第2个作业'), '已布置作业显示错误'
        find('.recorded-title').find_link('作业管理').click
        assert page.has_content?('已布置的作业'), '作业管理返回失败'
      end
    end
  end
end
