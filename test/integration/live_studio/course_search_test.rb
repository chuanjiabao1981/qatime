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

    test 'course search tab' do
      assert find('.select-tab').has_link?('直播课')
      assert find('.select-tab').has_link?('一对一')
      assert find('.select-tab').has_link?('视频课')
    end

    # 按最近时间搜索
    test 'search by range' do
      find('.nav-all').hover
      click_on '近2个月'
      assert page.has_content?('近2个月')
    end

    # 年级查询
    test 'search by grade' do
      click_on '高一'
      assert page.has_content?('高一数学')
      assert page.has_content?('高一英语')
      assert page.has_no_content?('高二英语')
    end

    # 科目查询
    test 'search by subject' do
      click_on '数学'
      assert page.has_content?('高一数学')
      assert page.has_no_content?('高二英语')
    end

    # 状态查询
    test 'search by status' do
      click_on '招生中'
      assert page.has_link?('招生中的辅导班')
      assert page.has_no_link?('上课中的辅导班')
      click_on '开课中'
      assert page.has_link?('辅导班4')
      assert page.has_no_link?('招生中的辅导班')
    end

    # 销售类型查询
    test 'search by sell type' do
      click_on '收费课程'
      assert page.has_link?('测试辅导2班')
      assert page.has_no_link?('免费直播课1')
      click_on '免费课程'
      assert page.has_link?('免费直播课1')
      assert page.has_no_link?('测试辅导2班')
    end

    test 'search by tags' do
    end

    # 混合搜索
    test 'mix search' do
      find('.nav-all').hover
      click_on '近2个月'
      click_on '高一'
      click_on '数学'
      click_on '招生中'
      assert page.has_content?('招生中')
      assert page.has_content?('数学')
      assert page.has_content?('高一')
      assert page.has_content?('近2个月')
    end

    # 按价格排序
    test 'sort by price' do
      click_on '价格'
      assert page.has_content? '价格'
      click_on '价格'
      assert page.has_content? '价格'
    end

    # 按人气排序
    test 'sort by users_count' do
      click_on '人气'
      assert page.has_content? '人气'
      click_on '人气'
      assert page.has_content? '人气'
    end

    # 按发布时间排序
    test 'sort published_at' do
      click_on '最新'
      assert page.has_content? '最新'
      click_on '最新'
      assert page.has_content? '最新'
    end

    # 标签过滤测试
    test 'filter tag by subject and grade' do
      assert_equal 20, all(".nav-sub a").size, "没有显示所有标签"
      click_on '高一'
      assert page.has_no_content?("高考")
      assert page.has_no_content?("高考志愿")
      assert page.has_no_content?("奥数竞赛")
      click_on '高三'
      assert page.has_content?("高考")
      assert page.has_content?("高考志愿")
      assert page.has_no_content?("奥数竞赛")
      click_on '英语'
      assert page.has_content?("高考")
      assert page.has_content?("外教")
      click_on '数学'
      assert page.has_content?("高考")
      assert page.has_no_content?("高考志愿")
      assert page.has_no_content?("外教")
    end
  end
end
