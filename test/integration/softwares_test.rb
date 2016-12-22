require 'test_helper'

class SoftwaresTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "teacher visit download view" do
    teacher = users(:physics_teacher1)
    log_in_as(teacher)
    visit info_teacher_path(teacher)
    click_on '下载'

    assert page.has_content?('教师问答社区'), '软件不能显示'
    new_logout_as(teacher)
  end

  test 'create a software' do
    admin = users(:admin)
    log_in_as(admin)
    click_on "下载管理"
    click_button "新增"
    select('“答疑时间” 直播助手', from: 'software_software_category_id')
    attach_file('software_logo', "#{Rails.root}/test/integration/teacher-live.png")
    fill_in('software_version', with: '0.3.0')
    fill_in('software_description', with: '本次更新主要为了测试')
    fill_in('software_cdn_url', with: 'http://www.baidu.com')
    assert_difference "Software.count", 1 do
      click_on "新增软件"
    end
  end

  # 未登录访问下载页面
  test 'view software not signin' do
    visit root_path
    click_on '下载'
    assert page.has_content?('教师问答社区'), '直播器软件无法下载'
    assert page.has_content?('学生app'), '安卓应用无法下载'
  end
end
