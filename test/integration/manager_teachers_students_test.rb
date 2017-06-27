require 'test_helper'

class ManagerTeachersStudentsTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @manager = users(:manager)
    new_log_in_as(@manager)
    visit get_home_url(@manager)
  end

  def teardown
    new_logout_as(@manager)
    Capybara.use_default_driver
  end

  test "visit students" do
    click_on '资源管理'
    assert page.has_link?('学生管理')
    assert page.has_link?('老师管理')
    assert page.has_link?('学校管理')
    assert page.has_content? '手机'
    assert page.has_content? '家长手机'
    assert page.has_content? 'student1'
    assert_equal Student.by_city(@manager.city_id).count, all('.sold-tab tr').size - 1, '工作站城市下的学生未区分'
  end

  test "visit teachers" do
    click_on '资源管理'
    click_on '老师管理'
    assert page.has_content? '昵称	'
    assert page.has_content? '类型'
    assert page.has_content? '科目'
    assert page.has_content? 'teacher_one'
    click_on '通过', match: :first
    assert page.has_link? '不通过'
    assert_equal Teacher.by_city(@manager.city_id).count, all('.sold-tab tr').size - 1, '工作站城市下的老师未区分'
  end

  test "visit schools" do
    click_on '资源管理'
    click_on '学校管理'
    assert page.has_content? '阳泉二中'
    assert_equal @manager.workstations.first.city.schools.count, all('.sold-tab tr').size - 1, '工作站城市下的学校未区分'
    click_on '新增学校'
    fill_in :school_name, with: '北京幼儿园'
    click_on '保存'
    assert page.has_content? '北京幼儿园'
  end
end
