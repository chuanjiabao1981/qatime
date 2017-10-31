
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

  test "home teachers index" do
    visit home_path
    click_on '全部老师'
    click_on '高中'
    click_on '物理'
    assert page.has_link?('physics_teacher1')
    assert 2, page.all('.teacher-list li').size
  end

  test "home replays page" do
    visit replays_home_index_path
    assert page.has_content?('第3节')
    assert page.has_content?('老师：teacher1')
    assert page.has_link?('观看')
    assert Recommend::ReplayItem.default.items.count, page.all('.replays-list li').size
  end

  test "home replay page" do
    visit replays_home_index_path
    item = Recommend::ReplayItem.default.items.first
    visit replay_home_path(item)

    assert page.has_content? item.name
    assert page.has_content? "回放次数1"
    assert page.has_content? '年级科目'
    assert page.has_content? '视频时长'
    assert page.has_link? item.target.teacher.name
  end

  test "home page search" do
    visit home_path
    find(:css, '.fa-search').click
    fill_in :search_key, with: '发布'
    find(:css, '.fa-search').click
    assert page.has_link?('搜索相关老师')
    assert page.has_link?('发布的视频课2')
    assert page.has_link?('发布的视频课1')

    fill_in :search_key, with: '数学'
    find(:css, '.fa-search').click
    assert page.has_link?('数学辅导班4')
    click_on '搜索相关老师'
    assert page.has_link?('teacher_one')
    assert page.has_content?('高中数学')

    fill_in :search_key, with: '专属课'
    find(:css, '.fa-search').click
    click_on '搜索相关课程'
    assert page.has_link?('今日专属课1')
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
      assert page.has_link? name, '加盟城市未显示'
    end
    other_city = City.where(workstation_id: nil).first
    # assert page.has_no_link? other_city.name, "未加盟城市显示出来了"

    click_link '阳泉', match: :first
    assert find(:css, '.site-nav-left').has_content?('阳泉'), '城市切换不成功'
    click_link '切换'
    find(:css, '.city-list p').has_link? '阳泉', "最近选择未显示历史选择地区"

    select '北京', from: 'teacher_province_id'
    select '昌平', from: 'city_id'
    click_on '确定'
    assert find(:css, '.site-nav-left').has_content?('昌平'), '城市切换不成功'
    click_link '切换'
    click_on '选择全国'
  end

  test "home page line_items" do
    visit root_path
    assert page.has_link?('高三', href: live_studio.courses_path(q: {grade_eq: '高三'}))
    assert page.has_link?('答疑时间课程介绍')
    assert page.has_link?('直播课')
    assert page.has_link?('一对一')
    assert page.has_link?('视频课')
    assert page.has_link?('专属课')
    assert page.has_content?('往期直播回放')

    assert page.has_content? '今日直播'
    assert find('.live-today').has_content? '正在直播'
    assert find('.live-today').has_content? '尚未直播'
  end

  test "home page choiceness" do
    visit root_path
    assert page.has_content? '精心挑选为您推荐最优质的课程内容'

    assert_equal 4, page.all("#choiceness .item-handpick li").size, "精选内容显示数量显示不正确"

    interactive_course = live_studio_interactive_courses(:interactive_course_zhuji)
    assert page.has_link?('测试一对一诸暨'), "一对一精选未显示"
    assert page.has_xpath?("//a[@href='/live_studio/interactive_courses/#{interactive_course.id}']"), '一对一链接不正确'
    assert find('#choiceness').has_link?('发布的专属课1'), "精选内容未显示专属课"
  end

  test "home page free_courses" do
    visit root_path
    assert page.has_content? '免费课程'
    assert page.has_content? '让学习成本降到最低'
    courses = DataService::HomeData.new(nil).free_courses(limit: 4)
    assert_equal courses.count, page.all("#free_courses .item-handpick li").size, "免费课程显示数量显示不正确"
    courses.each do |course|
      assert page.has_link?(course.name)
      assert page.has_xpath?("//a[@href='/live_studio/#{course.model_name.route_key}/#{course.id}']"), '链接不正确'
    end
    assert find('#free_courses').has_link?('免费专属课1'), "免费课程未显示专属课"
  end

  test "home page newest_courses" do
    visit root_path
    assert page.has_content? '新课发布'
    assert page.has_content? '品尝新鲜知识的味道'
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
    assert page.has_content? '品质教育第一步-从选择高质量教师开始'
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
