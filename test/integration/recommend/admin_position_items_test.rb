require 'test_helper'

module Recommend
  class AdminPositionItemsTest < ActionDispatch::IntegrationTest

    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @admin = users(:admin)
      new_log_in_as(@admin)
    end

    def teardown
      new_logout_as(@admin)
      Capybara.use_default_driver
    end

    test 'admin manage banner_items' do
      click_on '首页管理'
      assert page.has_link?('广告位管理')
      assert page.has_link?('新增Banner')

      click_link '新增Banner'
      attach_file("banner_item_logo", "#{Rails.root}/test/integration/test.jpg", visible: false)
      fill_in :banner_item_index, with: '1'
      fill_in :banner_item_title, with: '轮播图1'
      fill_in :banner_item_link, with: 'http://www.baidu.com'
      select '阳泉', from: :banner_item_city_id

      assert_difference 'Recommend::BannerItem.count', 1 do
        click_on '保存'
        assert page.has_content?('轮播图1')
      end
    end

    test 'admin manage teacher_items' do
      click_on '首页管理'
      assert page.has_link?('老师推荐管理')
      click_on '老师推荐管理'
      assert page.has_link?('新增老师推荐')

      click_on '新增老师推荐'
      fill_in :teacher_item_index, with: '1'
      fill_in :teacher_item_title, with: '好老师啊'
      select '阳泉', from: :teacher_item_city_id

      assert_difference 'Recommend::TeacherItem.count', 1 do
        click_on '保存'
        assert page.has_content?('好老师啊')
      end
    end

    test 'admin manage choiceness_items' do
      click_on '首页管理'
      assert page.has_link?('精选内容管理')
      click_on '精选内容管理'
      assert page.has_link?('新增精选内容')

      click_on '新增精选内容'
      fill_in :choiceness_item_index, with: '1'
      fill_in :choiceness_item_title, with: '好课程啊'
      select '阳泉', from: :choiceness_item_city_id

      select '测试辅导2班', from: :choiceness_item_target_id
      select '最受欢迎', from: :choiceness_item_tag_one
      select '免费试听', from: :choiceness_item_tag_two

      assert_difference 'Recommend::ChoicenessItem.count', 1 do
        click_on '保存'
        assert page.has_content?('好课程啊')
        assert page.has_content?('标签1: 最受欢迎')
        assert page.has_content?('标签2: 免费试听')
      end
    end

    test 'admin manage choiceness_items edit interactive_course' do
      item = Recommend::ChoicenessItem.last
      visit recommend.edit_choiceness_item_path(item)

      select '一对一', from: :choiceness_item_target_type
      select '测试一对一', from: :choiceness_item_target_id
      click_on '保存'
      sleep(1)
      assert_equal item.reload.target.name, '测试一对一'
    end

  end
end
