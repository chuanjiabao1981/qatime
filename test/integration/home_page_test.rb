
require 'test_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!
class HomePageTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test 'home page switch_city' do
    visit home_path
    click_link '切换'

    assert page.has_link? '选择全国'
    assert page.has_link? '全国'
    assert page.has_select? 'teacher_province_id'
    assert page.has_select? 'city_id'
    assert page.has_content? '(城市已精确到县级单位)'
    assert page.has_content? '按拼音首字母：'
    assert page.has_content? '如果没有您要找的城市，则该城市暂未加盟'

    city_names = City.has_default_workstation.pluck(:name)
    city_names.each do |name|
      assert page.has_link?(name), '加盟城市未显示'
    end
    other_city = City.where(workstation_id: nil).first
    assert page.has_no_link?(other_city.name), "未加盟城市显示出来了"

    click_link '阳泉', match: :first
    assert find(:css, '.site-nav-left').has_content?('阳泉'), '城市切换不成功'
    click_link '切换'
    assert find(:css, '.city-list p').has_link?('阳泉'), "最近选择未显示历史选择地区"

    select '北京', from: 'teacher_province_id'
    select '昌平', from: 'city_id'
    click_on '确定'
    assert find(:css, '.site-nav-left').has_content?('昌平'), '城市切换不成功'
    click_link '切换'
    click_on '选择全国'
  end

  test "home page choiceness" do
    visit root_path
    assert_equal 8, page.all("#choiceness .item-handpick li").size, "精选内容显示数量显示不正确"
    assert_equal 5, page.all("#choiceness .item-handpick li.default").size, "默认精选内容显示数量显示不正确"

    interactive_course = live_studio_interactive_courses(:interactive_course_zhuji)
    assert page.has_link?('测试一对一诸暨'), "一对一精选未显示"
    assert page.has_xpath?("//a[@href='/live_studio/interactive_courses/#{interactive_course.id}']"), '一对一链接不正确'
  end

  test "home page newest_courses" do
    visit root_path
    assert page.has_content? '新课发布'
    assert_equal 4, page.all("#newest_courses .item-handpick li").size, "新课发布显示数量显示不正确"
    courses = LiveService::RankManager.rank_of('all_published_rank')
    courses.each do |course|
      assert page.has_link?(course.name)
      assert page.has_xpath?("//a[@href='/live_studio/#{course.model_name.route_key}/#{course.id}']"), '链接不正确'
    end
  end

  test "home page teachers" do
    visit root_path
    assert page.has_content? '教师推荐'
    assert page.has_link? '更换'
    teachers = DataService::HomeData.new(nil).teachers
    assert_equal page.all('#recommend_teacher li').size, 6
    click_on '更换'
    sleep(1)
    assert_equal page.all('#recommend_teacher li').size, teachers.count - 6
    click_on '更换'
    sleep(1)
    assert_equal page.all('#recommend_teacher li').size, 6
  end
end
