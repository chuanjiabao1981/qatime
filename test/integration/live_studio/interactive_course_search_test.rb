require 'test_helper'

module LiveStudio
  class InteractiveCourseSearchTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      visit main_app.root_path
      click_on '一对一'
    end

    def teardown
      Capybara.use_default_driver
    end

    test 'search page' do
      assert page.has_content?('最新')
      click_on '高一'
      assert_equal '高一', find('.grade-filter .active').text, "年级没有选中"
      click_on '物理'
      assert_equal '物理', find('.subject-filter .active').text, '科目没有选中'
      click_on '生物'
      assert_equal '生物', find('.subject-filter .active').text, '科目没有选中'
      assert page.has_content?('未找到符合条件的课程')
    end

    # 按价格排序
    test 'sort by price' do
      click_on '价格'
      assert page.has_content?('价格')
      click_on '价格'
      assert page.has_content?('价格')
    end

    # 按发布时间排序
    test 'sort published_at' do
      assert page.has_content?('最新')
      click_on '最新'
      assert page.has_content?('最新')
      click_on '最新'
      assert page.has_content?('最新')
    end

    test 'interactive course detail' do
      click_on '第2-1个一对一直播'
      assert page.has_content?('500.00'), "价格没有显示"
      assert page.has_content?('立即报名'), "报名链接未显示"
      assert page.has_content?('teacher1'), "教师没没有显示"
      assert page.has_content?('teacher2'), "教师没没有显示"
    end
  end
end
