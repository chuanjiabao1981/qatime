require 'test_helper'

module LiveStudio
  class VideoCourseSearchTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      visit live_studio.video_courses_path
    end

    def teardown
      Capybara.use_default_driver
    end

    test 'search page' do
      assert page.has_content?('最新')
      # assert page.has_link?('全部课程')
      assert page.has_link?('收费课程')
      assert page.has_link?('免费课程')
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

    test 'search sell_type' do
      charge_course = live_studio_video_courses(:published_video_course1)
      free_course = live_studio_video_courses(:published_video_course2)
      assert page.has_link? charge_course.name
      assert page.has_link? free_course.name

      click_on '收费课程'
      assert page.has_link?(charge_course.name)
      assert !page.has_link?(free_course.name)
      click_on '免费课程'
      assert !page.has_link?(charge_course.name)
      assert page.has_link?(free_course.name)
    end
  end
end
