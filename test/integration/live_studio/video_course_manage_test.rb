require 'test_helper'

module LiveStudio
  class VideoCourseManageTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      new_logout_as(@user) if @user
      Capybara.use_default_driver
    end

    # 创建视频课
    test 'complete and publish video course' do
      @user = users(:manager)
      new_log_in_as(@user)
      click_on '视频课'
      click_on '课程管理'
    end
  end
end
