require 'test_helper'

class ManagerHomeTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @manager = users(:manager_zhuji)
    new_log_in_as(@manager)
  end

  def teardown
    new_logout_as(@manager)
    Capybara.use_default_driver
  end

  test "visit home statistics" do
    visit managers_home_path
    assert page.has_content?('销售曲线')
    assert page.has_link?('销售明细')
    assert page.has_content?('销售总额')
    select('近2月', from: 'statistics_days')

    click_on '销售明细'
    assert page.has_link?('返回')
    assert page.has_link?('售出记录')
    assert page.has_link?('退售记录')
    assert page.has_content?('销售内容（课程名称）')
    click_on '退售记录'
    assert page.has_content?('退款内容（课程名称）')
  end

  test "visit home teaching_lessons" do
    visit managers_home_path
    assert page.has_content?('正在上课')
    assert page.has_link?('全部')
    assert_equal 2, page.all('.classing > ul > li').size, '正在上课的课时不对'
    assert page.has_content? '一对一互动课程-第一课时'
    assert page.has_link?('进入听课')

    click_on '全部'
    assert page.has_content?('正在上课')
    assert page.has_content? '一对一互动课程-第一课时'
  end

  test "visit home action_records" do
    visit managers_home_path
    assert page.has_content? '实时动态'
    assert page.has_link? '全部动态'
    click_on '全部动态'
  end

  test "visit home sale_tasks" do
    visit managers_home_path
    assert page.has_content? '考核进度跟踪'
    assert page.has_link? '考核记录'
    click_on '考核记录'
    assert page.has_content? '考核结果'
    click_on '查看明细', match: :first
    assert page.has_content? '考核期开始日'
    assert page.has_content? '考核扣款金额'
  end

end
