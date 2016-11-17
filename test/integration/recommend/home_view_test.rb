require 'test_helper'

module Recommend
  class HomeViewTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      Capybara.use_default_driver
    end

    test 'admin manage items' do
      visit home_path
      click_link '切换'
      click_link '阳泉', match: :first
      assert page.has_content?('阳泉')
    end
  end
end
