require 'test_helper'

class SoftwareCategoriesTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @admin = users(:admin)
    new_log_in_as(@admin)
    visit get_home_url(@admin)
  end

  def teardown
    new_logout_as(@admin)
    Capybara.use_default_driver
  end

  test "admin software category" do
    visit admins_software_categories_path
    assert page.has_content?('软件分类')
    click_on '新增', match: :first
    attach_file('software_category_logo', "#{Rails.root}/test/integration/student-app.png")
    fill_in :software_category_title, with: 'App-学生版'
    fill_in :software_category_sub_title, with: '小标题'
    fill_in :software_category_desc, with: '介绍内容'
    select 'Android', from: 'software_category_platform'
    select 'Student', from: 'software_category_role'
    select 'Student client', from: 'software_category_category'
    fill_in :software_category_position, with: 1

    assert_difference "SoftwareCategory.count", 1 do
      click_on '新增软件分类'
    end
  end
end
