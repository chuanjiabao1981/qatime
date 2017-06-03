require 'test_helper'

module Recommend
  class AdminPositionItemsTest < ActionDispatch::IntegrationTest

    def setup
      @routes = Engine.routes
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

    test 'manager banner_items' do
      click_on '网页管理'
      assert page.has_link?('首页管理')
      assert page.has_link?('Banner')
      assert page.has_link?('精选内容')
      assert page.has_link?('教师推荐')
      assert page.has_link?('新增')

      click_on '新增'
      attach_file("banner_item_logo", "#{Rails.root}/test/integration/test.jpg", visible: false)
      fill_in :banner_item_index, with: '1'
      fill_in :banner_item_title, with: '轮播图1'
      fill_in :banner_item_link, with: 'http://www.baidu.com'

      assert_difference 'Recommend::BannerItem.count', 1 do
        click_on '保存'
        assert page.has_content?('轮播图1')
      end
      sleep(1)
      click_on '编辑', match: :first
      fill_in :banner_item_title, with: '轮播图2'
      click_on '保存'
      assert page.has_content?('轮播图2')
      message = accept_prompt(with: '确定删除?') do
        click_on '删除', match: :first
      end
      assert page.has_no_content?('轮播图2')
    end

    test 'manager teacher_items' do
      click_on '网页管理'
      click_on '教师推荐'
      assert page.has_content?('老师头像')
      assert page.has_content?('跳转链接')

      click_on '新增'
      fill_in :teacher_item_index, with: '1'
      fill_in :teacher_item_title, with: '好老师啊'

      assert_difference 'Recommend::TeacherItem.count', 1 do
        click_on '保存'
        assert page.has_content?('好老师啊')
      end
      sleep(1)
      click_on '编辑', match: :first
      fill_in :teacher_item_title, with: '好老师啊2'
      click_on '保存'
      assert page.has_content?('好老师啊2')
      message = accept_prompt(with: '确定删除?') do
        click_on '删除', match: :first
      end
      assert page.has_no_content?('好老师啊2')
    end

    test 'manager choiceness_items' do
      click_on '网页管理'
      click_on '精选内容'
      assert page.has_content?('预览图')
      assert page.has_content?('推荐标签')

      click_on '新增'
      fill_in :choiceness_item_index, with: '1'
      fill_in :choiceness_item_title, with: '好课程啊'

      select '直播课', from: :choiceness_item_target_type
      select '数学辅导班1', from: :choiceness_item_target_id
      select '最受欢迎', from: :choiceness_item_tag_one
      select '免费试听', from: :choiceness_item_tag_two

      assert_difference 'Recommend::ChoicenessItem.count', 1 do
        click_on '保存'
        assert page.has_content?('好课程啊')
        assert page.has_content?('标签1: 最受欢迎')
        assert page.has_content?('标签2: 免费试听')
      end

      sleep(1)
      click_on '编辑', match: :first
      select '数学辅导班2', from: :choiceness_item_target_id
      click_on '保存'
      assert page.has_link?('数学辅导班2')
      message = accept_prompt(with: '确定删除?') do
        click_on '删除', match: :first
      end
      assert page.has_no_content?('好课程啊')
    end

  end
end
