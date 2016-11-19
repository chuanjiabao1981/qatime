require 'test_helper'

module Recommend
  class ManagerManageTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager)

      new_log_in_as(@manager)
    end

    def teardown
      new_logout_as(@manager)
      Capybara.use_default_driver
    end

    test 'admin manage items' do
      position = recommend_positions(:index_teacher_recommend)
      visit recommend.manager_position_path(position)
      click_link 'new'
      fill_in :teacher_item_title, with: 'test'
      fill_in :teacher_item_index, with: '1'
      select 'teacher_one', from: :teacher_item_target_id
      select '阳泉', from: :teacher_item_city_id
      click_on '新增教师推荐'
      assert page.has_content?('Item was successfully created.')
      assert page.has_content?('test')
    end
  end
end
