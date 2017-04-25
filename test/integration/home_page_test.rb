
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

  test "home page choiceness" do
    visit root_path
    assert_equal 8, page.all("#choiceness .item-handpick li").size, "精选内容显示数量显示不正确"
    assert_equal 5, page.all("#choiceness .item-handpick li.default").size, "默认精选内容显示数量显示不正确"

    interactive_course = live_studio_interactive_courses(:interactive_course_zhuji)
    assert page.has_link?('测试一对一诸暨'), "一对一精选未显示"
    assert page.has_xpath?("//a[@href='/live_studio/interactive_courses/#{interactive_course.id}']"), '一对一链接不正确'
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
