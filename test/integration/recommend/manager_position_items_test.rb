require 'test_helper'

module Recommend
  class ManagerPositionItemsTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager)
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
      assert page.has_link?('板块专题')
      assert page.has_link?('精彩回放')
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
      accept_prompt(with: '确定删除?') do
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
      accept_prompt(with: '确定删除?') do
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
      select '数学辅导班7', from: :choiceness_item_target_id
      select '最受欢迎', from: :choiceness_item_tag_one

      assert_difference 'Recommend::ChoicenessItem.count', 1 do
        click_on '保存'
        assert page.has_content?('好课程啊')
        assert page.has_content?('最受欢迎')
      end

      sleep(1)
      click_on '编辑', match: :first
      select '初始化辅导班', from: :choiceness_item_target_id
      select '免费试听', from: :choiceness_item_tag_one
      click_on '保存'
      assert page.has_link?('初始化辅导班')
      assert page.has_content?('免费试听')
      accept_prompt(with: '确定删除?') do
        click_on '删除', match: :first
      end
      assert page.has_no_content?('好课程啊')
    end

    test 'manager topic_items' do
      click_on '网页管理'
      click_on '板块专题'
      assert page.has_content?('标题')
      assert page.has_content?('跳转链接')

      click_on '新增'
      fill_in :topic_item_name, with: '社区送温暖'
      fill_in :topic_item_index, with: '1'
      fill_in :topic_item_title, with: '送的好啊'
      fill_in :topic_item_link, with: '/'
      assert_difference 'Recommend::TopicItem.count', 1 do
        click_on '保存'
        assert page.has_content?('社区送温暖')
      end
      sleep(1)
      click_on '编辑', match: :first
      fill_in :topic_item_name, with: '精选专区'
      click_on '保存'
      assert page.has_content?('精选专区')
      accept_prompt(with: '确定删除?') do
        click_on '删除', match: :first
      end
      assert page.has_no_content?('精选专区')
    end

    test 'manager replay_items' do
      click_on '网页管理'
      click_on '精彩回放'
      assert page.has_content?('课时名称')
      assert page.has_content?('仅显示推荐内容')

      click_on '新增'
      select '回放测试辅导班', from: :replay_item_course_id
      sleep(3)
      select '第1节', from: :replay_item_target_id
      check :replay_item_top
      assert_difference 'Recommend::ReplayItem.count', 1 do
        click_on '保存'
        assert page.has_content?('第1节')
      end
      sleep(1)
      click_on '编辑', match: :first
      select '第2节', from: :replay_item_target_id
      click_on '保存'
      assert page.has_content?('第2节')
      accept_prompt(with: '确定删除?') do
        click_on '删除', match: :first
      end
      assert page.has_no_content?('第2节')
    end
  end
end
