require 'test_helper'

module Wap
  class SessionsTest < ActionDispatch::IntegrationTest
    def setup
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:student1)
    end

    def teardown
      Capybara.use_default_driver
    end

    test 'student wap login' do
      visit new_wap_session_path

      fill_in :user_login_account, with: @student.email
      fill_in :user_password, with: 'password'
      click_on "立即登录"

      assert page.has_content?('欢迎登录!'), "登录不成功"
    end
  end
end
