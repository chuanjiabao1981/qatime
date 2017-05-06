require 'test_helper'

module LiveStudio
  class CourseSearchTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      visit live_studio.courses_path
    end

    def teardown
    end

    # 按最近时间搜索
    test 'search by range' do
      find('.nav-all').hover
      click_on '近2个月'
      assert page.has_content?('近2个月')
    end

    # 年级查询
    test 'search by grade' do
      find('.nav-grade').hover
      click_on '高一'
      assert page.has_content?('高一')
      assert page.has_no_content?('六年级')
    end

    # 科目查询
    test 'search by subject' do
      find('.nav-subject').hover
      click_on '数学'
      assert page.has_content?('数学')
      assert page.has_no_content?('语文')
    end

    # 状态查询
    test 'search by status' do
      find('.nav-state').hover
      click_on '招生中'
      assert page.has_content?('招生中')
      assert page.has_content?('招生中的辅导班')
      assert page.has_no_content?('上课中的辅导班')
    end

    test 'search by tags' do
    end

    # 混合搜索
    test 'mix search' do
      find('.nav-all').hover
      click_on '近2个月'
      find('.nav-grade').hover
      click_on '高一'
      find('.nav-subject').hover
      click_on '数学'
      find('.nav-state').hover
      click_on '招生中'
      assert page.has_content?('招生中')
      assert page.has_content?('数学')
      assert page.has_content?('高一')
      assert page.has_content?('近2个月')
    end

    # 按价格排序
    test 'sort by price' do
      click_on '价格'
      assert_equal '价格 ▲', page.find('.nav-price.active').text
      click_on '价格'
      assert_equal '价格 ▼', page.find('.nav-price.active').text
    end

    # 按人气排序
    test 'sort by users_count' do
      click_on '人气'
      assert_equal '人气 ▲', page.find('.nav-moods.active').text
      click_on '人气'
      assert_equal '人气 ▼', page.find('.nav-moods.active').text
    end

    # 按发布时间排序
    test 'sort published_at' do
      click_on '最新'
      assert_equal '最新 ▲', page.find('.nav-news.active').text
      click_on '最新'
      assert_equal '最新 ▼', page.find('.nav-news.active').text
    end

    # 标签过滤测试
    test 'filter tag by subject and grade' do
      assert_equal 20, all(".aside-list-nav a").size, "没有显示所有标签"
      find('.nav-grade').hover
      click_on '高一'
      assert page.has_no_content?("高考")
      assert page.has_no_content?("高考志愿")
      assert page.has_no_content?("奥数竞赛")
      find('.nav-grade').hover
      click_on '高三'
      assert page.has_content?("高考")
      assert page.has_content?("高考志愿")
      assert page.has_no_content?("奥数竞赛")
      find('.nav-subject').hover
      click_on '英语'
      assert page.has_content?("高考")
      assert page.has_content?("外教")
      find('.nav-subject').hover
      click_on '数学'
      assert page.has_content?("高考")
      assert page.has_no_content?("高考志愿")
      assert page.has_no_content?("外教")
    end
  end
end
