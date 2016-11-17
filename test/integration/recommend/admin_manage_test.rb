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

    test 'admin manage positions' do
      click_on '推荐管理'
      click_link 'new'
      fill_in :position_name, with: 'new_test'
      fill_in :position_kee, with: 'new_test'
      select '教师推荐', from: :position_klass_name
      click_on '新增推荐位'
      assert page.has_content?('Position was successfully created.')
      click_on '推荐管理'
      accept_prompt(with: "Are you sure?") do
        click_link '启用', match: :first
      end
      assert page.has_content?('Position was successfully changed.')
      accept_prompt(with: "Are you sure?") do
        click_link '删除', match: :first
      end
      assert page.has_content?('Position was successfully destroyed.')
    end

    test 'admin manage items' do
      position = recommend_positions(:index_teacher_recommend)
      visit recommend.admin_position_path(position)
      click_link 'new'
      fill_in :teacher_item_title, with: 'test'
      fill_in :teacher_item_index, with: '1'
      select 'teacher_one', from: :teacher_item_target_id
      select '最热', from: :teacher_item_reason
      select '阳泉', from: :teacher_item_city_id
      click_on '新增教师推荐'
      assert page.has_content?('Item was successfully created.')
    end
  end
end
