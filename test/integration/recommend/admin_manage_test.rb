require 'test_helper'

module Recommend
  class AdminManageTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @admin = users(:admin)

      new_log_in_as(@admin)
    end

    def teardown
      new_logout_as(@admin)
      Capybara.use_default_driver
    end

    test 'admin manage positions ' do
      click_on '推荐管理'
      click_link 'new'
      fill_in :position_name, with: 'new_test'
      fill_in :position_kee, with: 'new_test'
      select '教师推荐', from: :position_klass_name
      click_on '新增推荐位'
      assert page.has_content?('Position was successfully created.')
      accept_prompt(with: "Are you sure?") do
        click_link '启用', match: :first
      end
      assert page.has_content?('Position was successfully changed.')
      accept_prompt(with: "Are you sure?") do
        click_link '删除', match: :first
      end
      assert page.has_content?('Position was successfully destroyed.')
    end
  end
end
