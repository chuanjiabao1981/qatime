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
      visit get_home_url(@admin)
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
      assert page.has_link?('新增老师')

      click_on '新增老师'
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

      assert_difference 'Recommend::ChoicenessItem.count', 1 do
        click_on '保存'
        assert page.has_content?('好课程啊')
        assert page.has_content?('最受欢迎')
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

    test 'admin manage replay_items' do
      click_on '首页管理'
      assert page.has_link?('往期直播回放管理')
      click_on '往期直播回放管理'
      assert page.has_link?('新增回放')
      assert page.has_content?('仅显示推荐内容')

      click_on '新增回放'
      select '专属课', from: :replay_item_course_type
      select '直播课', from: :replay_item_course_type
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

    test 'admin manage topic_items' do
      click_on '首页管理'
      assert page.has_link?('板块专题管理')
      click_on '板块专题管理'
      assert page.has_link?('新增专题')

      click_on '新增专题'
      fill_in :topic_item_name, with: '专题送温暖1'
      fill_in :topic_item_index, with: '1'
      fill_in :topic_item_title, with: '描述1'
      fill_in :topic_item_link, with: '/home'
      click_on '保存'
      sleep(1)
      assert page.has_content?('该城市排序位置已存在')

      assert_difference 'Recommend::TopicItem.count', 1 do
        fill_in :topic_item_index, with: '2'
        click_on '保存'
        assert page.has_content?('专题送温暖1')
      end
      sleep(1)
      item = Recommend::TopicItem.last
      click_link('编辑', href: recommend.edit_topic_item_path(item))
      fill_in :topic_item_name, with: '专题送温暖2'
      click_on '保存'

      assert page.has_content?('专题送温暖2')
      accept_prompt(with: '确定删除?') do
        click_link('删除', href: recommend.topic_item_path(item))
      end
      assert page.has_no_content?('专题送温暖2')
    end
  end
end
